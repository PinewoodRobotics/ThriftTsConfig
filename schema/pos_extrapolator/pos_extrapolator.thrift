include "../common/common.thrift"
include "./kalman_filter.thrift"

namespace py config.pos_extrapolator

struct PosExtrapolatorMessageConfig {
    1: required string post_tag_input_topic,
    2: required string post_odometry_input_topic,
    3: required string post_imu_input_topic,
    4: required string post_robot_position_output_topic,
}

enum OdometryPositionSource {
    ABSOLUTE = 0,
    ABS_CHANGE = 1,
    DONT_USE = 2,
}

struct OdomConfig {
    1: required OdometryPositionSource position_source,
    2: required bool use_rotation,
}

struct ImuConfig {
    1: required bool use_rotation,
    2: required bool use_position,
    3: required bool use_velocity,
}

enum TagUseImuRotation {
    ALWAYS = 0,
    WHILE_NO_OTHER_ROTATION_DATA = 1,
    NEVER = 2,
}

enum TagNoiseAdjustMode {
    ADD_WEIGHT_PER_M_DISTANCE_TAG = 0,
    ADD_WEIGHT_PER_TAG_CONFIDENCE = 1,
}

struct TagNoiseAdjustConfig {
    1: required double weight_per_m_from_distance_from_tag,
    2: required double weight_per_degree_from_angle_error_tag,
    3: required double weight_per_confidence_tag,
    4: required double min_distance_from_tag_to_use_noise_adjustment,
}

struct AprilTagConfig {
  1: required map<i32, common.Point3> tag_position_config,
  2: required map<string, common.Point3> camera_position_config,
  3: required TagUseImuRotation tag_use_imu_rotation,
  4: required list<TagNoiseAdjustMode> noise_change_modes = [],
  5: required TagNoiseAdjustConfig tag_noise_adjust_config,
}

enum DataSources {
    APRIL_TAG = 0,
    ODOMETRY = 1,
    IMU = 2,
}

struct PosExtrapolator {
    1: required PosExtrapolatorMessageConfig message_config,
    2: required list<DataSources> enabled_data_sources,
    3: required AprilTagConfig april_tag_config,
    4: required OdomConfig odom_config,
    5: required map<string, ImuConfig> imu_config,
    6: required kalman_filter.KalmanFilterConfig kalman_filter_config,
    7: optional double time_s_between_position_sends,
    8: optional double future_position_prediction_margin_s,
}