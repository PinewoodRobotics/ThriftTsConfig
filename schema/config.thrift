namespace py config

include "./apriltag/apriltag.thrift"
include "./camera/camera.thrift"
include "./lidar/lidar.thrift"
include "./pos_extrapolator/pos_extrapolator.thrift"
include "./pathfinding/pathfinding.thrift"
include "./image_recognition/image_recognition.thrift"
include "./obj_pose_extrapolator/obj_pose_extrapolator.thrift"
include "./camera_processor/camera_processor.thrift"

struct Config {
    1: required pos_extrapolator.PosExtrapolator pos_extrapolator,
    2: required list<camera.CameraParameters> cameras,
    3: required map<string, lidar.LidarConfig> lidar_configs,
    4: required apriltag.AprilDetectionConfig april_detection,
    5: required pathfinding.PathfindingConfig pathfinding,
    6: required bool record_replay,
    7: required string replay_folder_path,
    8: optional image_recognition.ObjectRecognitionConfig object_recognition,
    9: optional obj_pose_extrapolator.ObjPoseExtrapolatorConfig obj_pose_extrapolator,
    10: required map<string, list<camera_processor.CameraPipelineType>> pi_name_to_pipeline_types,
}