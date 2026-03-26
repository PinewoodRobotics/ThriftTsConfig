include "../common/common.thrift"
include "./kalman_filter.thrift"

namespace py config.pos_extrapolator

struct PosExtrapolatorMessageConfig {
    1: required string post_tag_input_topic,
    2: required string post_odometry_input_topic,
    3: required string post_imu_input_topic,
    4: required string post_robot_position_output_topic,
}

struct OdomConfig {
}

struct ImuConfig {
    1: required bool use_velocity,
}

enum TagNoiseAdjustMode {
    ADD_WEIGHT_PER_M_DISTANCE_TAG = 0,
    ADD_WEIGHT_PER_TAG_CONFIDENCE = 1,
    ADD_ADDITIVE_NOISE_BY_TAG_ID = 2,
}

enum TagRejectMode {
    REJECT_OVER_MAX_DISTANCE_FROM_TAG = 0,
    REJECT_UNDER_MIN_TAG_CONFIDENCE = 1,
}

struct TagNoiseAdjustConfig {
    1: required double weight_per_m_from_distance_from_tag,
    2: required double weight_per_degree_from_angle_error_tag,
    3: required double weight_per_confidence_tag,
    4: required double min_distance_from_tag_to_use_noise_adjustment,
    5: required map<i32, common.GenericVector> additive_noise_by_tag_id,
}

struct TagRejectConfig {
    1: required double max_distance_from_tag,
    2: required double min_tag_confidence,
}

struct AprilTagConfig {
  1: required map<i32, common.Point3> tag_position_config,
  2: required map<string, common.Point3> camera_position_config,
  3: required list<TagNoiseAdjustMode> noise_change_modes = [],
  4: required TagNoiseAdjustConfig tag_noise_adjust_config,
  5: required bool insert_predicted_global_rotation,
  6: optional double apriltag_mahalanobis_gate_threshold,
  7: required list<TagRejectMode> reject_modes = [],
  8: required TagRejectConfig tag_reject_config,
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
