include "../common/common.thrift"
include "./camera_processor.thrift"

namespace py config.camera

enum CameraType {
  OV2311,
  ULTRAWIDE_100,
}

struct Intrinsics {
  1: required common.GenericMatrix camera_matrix,
  2: required common.GenericVector dist_coeff,
  3: required i32 width,
  4: required i32 height,
}

struct VideoFeed {
  1: required i32 max_fps,
  2: required i32 exposure_time,
  3: optional i32 brightness,
}

struct Camera {
  1: required string pi_connected_to,
  2: required string camera_port_path,
  3: required string camera_alias_name,
  4: required CameraType camera_type,
  5: required Intrinsics intrinsics,
  6: required VideoFeed video_feed,
  7: required camera_processor.CameraProcessorConfig camera_processor_config,
}