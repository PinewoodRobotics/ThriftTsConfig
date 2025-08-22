import { CameraType } from "generated/thrift/gen-nodejs/camera_types";
import { KalmanFilterSensorType } from "generated/thrift/gen-nodejs/kalman_filter_types";

export const MapUtil = {
  fromRecord<K extends string | number | symbol, V>(
    record: Record<K, V>
  ): globalThis.Map<K, V> {
    return new globalThis.Map(Object.entries(record) as [K, V][]);
  },
};

export enum SensorType {
  APRIL_TAG = 0,
  IMU = 1,
  ODOM = 2,
}

export const KalmanFilterSensorTypeUtil = {
  fromEnum(type: SensorType): KalmanFilterSensorType {
    switch (type) {
      case SensorType.APRIL_TAG:
        return 0 as KalmanFilterSensorType;
      case SensorType.IMU:
        return 2 as KalmanFilterSensorType;
      case SensorType.ODOM:
        return 1 as KalmanFilterSensorType;
      default:
        throw new Error(`Invalid sensor type: ${type}`);
    }
  },
};

export enum CameraTypeE {
  OV2311 = "OV2311",
}

export const CameraTypeUtil = {
  fromEnum(type: CameraTypeE): CameraType {
    switch (type) {
      case CameraTypeE.OV2311:
        return 0 as CameraType;
      default:
        throw new Error(`Invalid camera type: ${type}`);
    }
  },
};
