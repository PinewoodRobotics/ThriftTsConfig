import {
  KalmanFilterSensorType,
  type KalmanFilterConfig,
} from "generated/thrift/gen-nodejs/kalman_filter_types";
import { MatrixUtil, VectorUtil } from "../../util/math";

export const kalman_filter: KalmanFilterConfig = {
  initial_state_vector: VectorUtil.fromArray([0.0, 0.0, 0.0]),
  uncertainty_matrix: MatrixUtil.buildMatrixFromDiagonal([1.0, 1.0, 1.0]),
  process_noise_matrix: MatrixUtil.buildMatrixFromDiagonal([0.1, 0.1, 0.05]),
  sensors: {
    [KalmanFilterSensorType.APRIL_TAG]: {
      camera_1: {
        measurement_noise_matrix: MatrixUtil.buildMatrixFromDiagonal([
          0.5, 0.5, 0.25,
        ]),
      },
    },
  },
};
