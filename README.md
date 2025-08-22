# ThriftTsConfig

A TypeScript configuration management system for robotics applications using Apache Thrift serialization.

## Quick Start

1. **Install dependencies**

   ```bash
   npm install
   ```

2. **Generate Thrift types**

   ```bash
   npm run generate-thrift
   ```

3. **Create your config**
   Copy the example configuration:

   ```bash
   cp -r example_config/ my_robot_config/
   ```

4. **Generate binary config**
   ```bash
   npm run config -- --dir my_robot_config/
   ```

## What it does

This tool takes your robot configuration (cameras, sensors, pathfinding, etc.) and converts it into a compact binary format that your robot can quickly read. It handles:

- **Camera settings** - Multiple camera configurations
- **LiDAR sensors** - Various LiDAR device setups
- **April tag detection** - Vision-based positioning
- **Position tracking** - Kalman filters and odometry
- **Pathfinding** - Navigation configurations
- **Recording** - Data capture settings

## Output Formats

- **Binary** (default) - Fast, compact format for robots
- **JSON** - Human-readable format for debugging
- **JSON + Binary** - Both formats combined

## Project Structure

```
example_config/     # Sample robot configurations
schema/            # Thrift schema definitions
generated/         # Auto-generated TypeScript types
scripts/          # Build and conversion tools
```

## Usage Examples

```bash
# Generate binary config for your robot
npm run config -- --dir my_robot_config/

# Output as JSON for debugging
npm run config -- --dir my_robot_config/ json

# Save to file instead of stdout
npm run config -- --dir my_robot_config/ file
```
