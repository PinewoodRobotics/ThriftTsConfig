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
    UNTIL_FIRST_NON_TAG_ROTATION = 1,
    NEVER = 2,
    WHEN_TAG_BASED_DIFFERENT = 3,
}

enum TagDisambiguationMode {
    NONE = 0,
    LEAST_ANGLE = 1,
    LEAST_DISTANCE = 2,
    LEAST_ANGLE_AND_DISTANCE = 3,
}

enum TagNoiseAdjustMode {
    ADD_WEIGHT_PER_M_DISTANCE_TAG = 0,
    ADD_WEIGHT_PER_DEGREE_ERROR_ANGLE_TAG = 1,
    ADD_WEIGHT_PER_TAG_CONFIDENCE = 2,
}

struct TagNoiseAdjustConfig {
    1: optional double weight_per_m_from_distance_from_tag,
    2: optional double weight_per_degree_from_angle_error_tag,
    3: optional double weight_per_confidence_tag,
}

struct AprilTagConfig {
  1: required map<i32, common.Point3> tag_position_config,
  2: required TagDisambiguationMode tag_disambiguation_mode,
  3: required map<string, common.Point3> camera_position_config,
  4: required TagUseImuRotation tag_use_imu_rotation,
  5: required double disambiguation_time_window_s,
  6: optional list<TagNoiseAdjustMode> tag_noise_adjust_mode,
  7: optional TagNoiseAdjustConfig tag_noise_adjust_config,
}

struct PosExtrapolator {
    1: required PosExtrapolatorMessageConfig message_config,
    5: required bool enable_imu,
    6: required bool enable_odom,
    7: required bool enable_tags,
    8: required AprilTagConfig april_tag_config,
    9: required OdomConfig odom_config,
    10: required map<string, ImuConfig> imu_config,
    11: required kalman_filter.KalmanFilterConfig kalman_filter_config,
    12: optional double time_s_between_position_sends,
    13: optional string composite_publish_topic,
    14: optional double future_position_prediction_margin_s,
    15: optional bool log_relevant_ai_training_data,
}