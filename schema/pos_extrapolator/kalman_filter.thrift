include "../common/common.thrift"

namespace py config.kalman_filter

struct KalmanFilterSensorConfig {
    1: required common.GenericMatrix measurement_noise_matrix,
}

enum KalmanFilterSensorType {
    APRIL_TAG,
    ODOMETRY,
    IMU,
}

struct KalmanFilterConfig {
    1: required common.GenericVector state_vector,
    2: required common.GenericMatrix uncertainty_matrix,
    3: required common.GenericMatrix process_noise_matrix,
    4: required map<KalmanFilterSensorType, map<string, KalmanFilterSensorConfig>> sensors,
    5: required list<i32> dim_x_z,
}