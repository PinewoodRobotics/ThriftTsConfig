namespace py config

include "./lidar/lidar.thrift"
include "./camera_processor/camera.thrift"
include "./pos_extrapolator/pos_extrapolator.thrift"
include "./pathfinding/pathfinding.thrift"
include "./obj_pose_extrapolator/obj_pose_extrapolator.thrift"
include "./camera_processor/camera_processor.thrift"

struct Config {
    1: required pos_extrapolator.PosExtrapolator pos_extrapolator,
    2: required list<camera.Camera> cameras,
    3: required map<string, lidar.LidarConfig> lidar_configs,
    4: optional pathfinding.PathfindingConfig pathfinding,
}