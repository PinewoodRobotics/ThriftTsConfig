include "../common/common.thrift"

namespace py config.obj_pose_extrapolator

struct MessageConfig {
    1: required string robot_global_position_topic,
    2: required list<string> objects_out_topic,
    3: optional string lidar_out_topic,
}

struct KalmanFilterConfig {
    1: required common.GenericMatrix uncertainty_matrix,
    2: required common.GenericMatrix process_noise_matrix,
    3: required common.GenericMatrix measurement_noise_matrix,
}

struct ObjectDimensions {
    1: required double width_meters,
    2: required double height_meters,
    3: required double depth_meters,
}

struct ObjPoseExtrapolatorConfig {
    1: required MessageConfig message_config,
    2: required KalmanFilterConfig kalman_filter_config,
    3: required double distance_same_object_threshold_meters,
    4: required double time_disappear_seconds = 0.5,
    5: required map<string, ObjectDimensions> object_dimensions,
    6: required double update_rate_sec = 0.1,
}