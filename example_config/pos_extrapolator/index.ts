import {
  DataSources,
  type PosExtrapolator,
} from "generated/thrift/gen-nodejs/pos_extrapolator_types";
import { MatrixUtil, VectorUtil } from "../util/math";
import { nav_x_config } from "./imu_config/navx";
import { kalman_filter } from "./kalman_filter_config";
import { message_config } from "./message_config";
import { swerve_odom_config } from "./odom_config/swerve_odom";
import { comp_lab } from "./tag_config/comp_lab";

export const pose_extrapolator: PosExtrapolator = {
  message_config,
  enabled_data_sources: [
    DataSources.APRIL_TAG,
    DataSources.ODOMETRY,
    DataSources.IMU,
  ],
  april_tag_config: {
    tag_position_config: comp_lab,
    camera_position_config: {
      camera_1: {
        position: VectorUtil.fromArray<3>([0, 0, 0]),
        rotation: MatrixUtil.buildRotationMatrixFromYaw(0),
      },
    },
    noise_change_modes: [],
    tag_noise_adjust_config: {
      weight_per_m_from_distance_from_tag: 0.0,
      weight_per_degree_from_angle_error_tag: 0.0,
      weight_per_confidence_tag: 0.0,
      min_distance_from_tag_to_use_noise_adjustment: 0.0,
    },
    insert_predicted_global_rotation: true,
  },
  odom_config: swerve_odom_config,
  imu_config: nav_x_config,
  kalman_filter_config: kalman_filter,
  time_s_between_position_sends: 0.025,
  future_position_prediction_margin_s: 0.0,
};
