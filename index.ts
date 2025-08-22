import * as fs from "fs";
import { TBinaryProtocol, TBufferedTransport } from "thrift";
import * as path from "path";
import { pathToFileURL } from "url";

const args = process.argv.slice(2);
const dirIndex = args.findIndex((arg) => arg === "--dir");
const configDirArg =
  dirIndex !== -1 && dirIndex + 1 < args.length ? args[dirIndex + 1] : null;
const outputArg = ((): "stdout" | "file" => {
  if (args.includes("file")) return "file";
  return "stdout";
})();
const protocolArg = ((): "binary" | "json" | "json-binary" => {
  if (args.includes("json-binary")) return "json-binary";
  if (args.includes("json")) return "json";
  return "binary";
})();

const initialCwd = process.env.INIT_CWD || process.cwd();

try {
  process.chdir(initialCwd);
} catch {}

function resolveAbsolutePath(p: string): string {
  if (path.isAbsolute(p)) return p;
  return path.resolve(initialCwd, p);
}

function findConfigDir(startDir: string): string | null {
  const candidates = ["config", path.join("src", "config")];
  let current: string | null = path.resolve(startDir);

  while (current) {
    for (const rel of candidates) {
      const candidate = path.join(current, rel);
      if (fs.existsSync(candidate) && fs.statSync(candidate).isDirectory()) {
        if (fs.existsSync(path.join(candidate, "index.ts"))) {
          return candidate;
        }
      }
    }
    const parent = path.dirname(current);
    if (parent === current) break;
    current = parent;
  }
  return null;
}

/**
 * Generates a Thrift configuration in various output formats and protocols.
 *
 * This function serializes the imported configuration using Apache Thrift's binary protocol
 * and outputs it either to stdout or to a file depending on the specified parameters.
 *
 * The config directory can be specified using the --dir command line argument,
 * otherwise it will automatically search for a 'config/' directory in the current
 * and parent directories.
 *
 * @async
 * @function generateConfig
 * @param {("stdout" | "file")} output - The output destination:
 *   - "stdout": Output to console/terminal
 *   - "file": Write to config.bin file
 * @param {("binary" | "json" | "json-binary")} protocol - The output format:
 *   - "binary": Base64-encoded binary Thrift data
 *   - "json": Human-readable JSON format
 *   - "json-binary": Combined JSON and binary data
 * @returns {Promise<void>} Promise that resolves when configuration generation is complete
 * @throws {Error} Throws error if Thrift serialization fails, config directory not found, or file operations fail
 *
 * @example
 * // Generate binary config to stdout using automatic config directory detection
 * await generateConfig("stdout", "binary");
 *
 * @example
 * // Generate JSON config to file with specific config directory
 * // Run with: npm run config -- --dir /path/to/config
 * await generateConfig("file", "json");
 */
async function generateConfig(
  output: "stdout" | "file",
  protocol: "binary" | "json" | "json-binary"
) {
  let resolvedConfigDir: string | null = null;
  if (configDirArg) {
    resolvedConfigDir = resolveAbsolutePath(configDirArg);
    if (
      !fs.existsSync(resolvedConfigDir) ||
      !fs.statSync(resolvedConfigDir).isDirectory()
    ) {
      throw new Error(
        `Specified config directory not found: ${resolvedConfigDir}`
      );
    }
  } else {
    resolvedConfigDir = findConfigDir(initialCwd);
    if (!resolvedConfigDir) {
      throw new Error(
        "Config directory not specified and could not be auto-detected (looked for 'config/' or 'src/config/'). Use --dir <path>."
      );
    }
  }

  const configModulePath = path.join(resolvedConfigDir, "index.ts");
  const config = await import(pathToFileURL(configModulePath).href);

  const generatedTypesPath = path.resolve(
    __dirname,
    "generated",
    "thrift",
    "gen-nodejs",
    "config_types.js"
  );
  const { Config } = await import(pathToFileURL(generatedTypesPath).href);

  const configInstance = new Config(config.default || config);
  let binaryData: Buffer = Buffer.alloc(0);

  const transport = new TBufferedTransport(undefined, (buf) => {
    if (output === "file") {
      fs.writeFileSync("config.bin", Buffer.from(buf ?? ""));
    } else {
      binaryData = Buffer.from(buf ?? "");
    }
  });
  const protocol_ = new TBinaryProtocol(transport);

  configInstance[Symbol.for("write")](protocol_);
  transport.flush();

  if (output === "stdout") {
    let outputData: string;

    if (protocol === "json") {
      outputData = JSON.stringify(configInstance, null, 2);
    } else if (protocol === "json-binary") {
      const outputObj = {
        json: JSON.stringify(configInstance),
        binary_base64: binaryData.toString("base64"),
      };
      outputData = JSON.stringify(outputObj);
    } else {
      outputData = binaryData.toString("base64");
    }

    console.log(outputData);
  } else {
    fs.writeFileSync("config.bin", binaryData);
  }
}

export { generateConfig };

generateConfig(outputArg, protocolArg).catch(console.error);
