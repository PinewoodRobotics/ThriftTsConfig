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

enum TagDistanceDiscardMode {
    NONE = 0,
    DISCARD_DISTANCE_AWAY = 1,
    DISCARD_ANGLE_AWAY = 2,
    DISCARD_ANGLE_AND_DISTANCE_AWAY = 3,
    ADD_WEIGHT_PER_M_FROM_DISCARD_DISTANCE = 4,
    ADD_WEIGHT_PER_DEGREE_FROM_DISCARD_ANGLE = 5,
    ADD_WEIGHT = 6,
}

struct TagDistanceDiscardConfig {
  1: required double distance_threshold,
  2: required double angle_threshold_degrees,
  3: required double weight_per_m_from_discard_distance,
  4: required double weight_per_degree_from_discard_angle,
}

struct AprilTagConfig {
  1: required map<i32, common.Point3> tag_position_config,
  2: required TagDistanceDiscardMode tag_discard_mode,
  3: required map<string, common.Point3> camera_position_config,
  5: required TagUseImuRotation tag_use_imu_rotation,
  6: optional TagDistanceDiscardConfig discard_config,
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
}