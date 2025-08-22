import * as fs from "fs";
import { TBinaryProtocol, TBufferedTransport } from "thrift";
import * as path from "path";
import assert = require("assert");

// Parse command line arguments
const args = process.argv.slice(2);
const dirIndex = args.findIndex((arg) => arg === "--dir");
const configDirArg =
  dirIndex !== -1 && dirIndex + 1 < args.length ? args[dirIndex + 1] : null;

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
  assert(configDirArg, "config directory not specified");

  const configDir = path.resolve(configDirArg);
  if (!fs.existsSync(configDir) || !fs.statSync(configDir).isDirectory()) {
    throw new Error(`Specified config directory not found: ${configDir}`);
  }

  const config = await import(path.join(configDir, "index.ts"));
  const { Config } = await import(
    "generated/thrift/gen-nodejs/config_types.js"
  );

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

generateConfig("stdout", "binary").catch(console.error);
