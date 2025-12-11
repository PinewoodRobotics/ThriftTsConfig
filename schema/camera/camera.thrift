include "../common/common.thrift"

namespace py config.camera

enum CameraType {
    OV2311,
    VIDEO_FILE,
    MOST_RECENT_RECORDING,
    ULTRAWIDE_100
}

struct VideoFeedOptions {
  1: required bool send_feed,
  2: optional string publication_topic,
  3: required bool overlay_tags = false
  4: optional bool do_compression,
  5: optional i32 compression_quality,
}

struct CameraParameters {
    1: required string pi_to_run_on,
    2: required common.GenericMatrix camera_matrix,
    3: required common.GenericVector dist_coeff,
    4: required string camera_path,
    5: required i32 max_fps,
    6: required i32 width,
    7: required i32 height,
    8: required i32 flags,
    9: required i32 exposure_time,
    10: required string name,
    11: required CameraType camera_type,
    12: optional string video_file_path,
    13: required VideoFeedOptions video_options
    14: optional i32 brightness,
}