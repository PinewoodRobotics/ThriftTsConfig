namespace py config.apriltag

enum SpecialDetectorType {
  GPU_CUDA = 0,
}

struct SpecialDetectorConfig {
  1: required SpecialDetectorType type,
  2: required string py_lib_searchpath,
}

struct AprilDetectionConfig {
    1: required double tag_size,
    2: required string family,
    3: required i32 nthreads,
    4: required double quad_decimate,
    5: required double quad_sigma,
    6: required bool refine_edges,
    7: required double decode_sharpening,
    8: required string tag_output_topic,
    9: optional SpecialDetectorConfig special_detector_config,
}
