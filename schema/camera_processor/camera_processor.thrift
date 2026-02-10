include "./apriltag.thrift"
include "./image_recognition.thrift"
include "./video_stream.thrift"

namespace py config.camera_processor

enum CameraPipelineType {
  APRIL_TAGS = 0,
  IMAGE_RECOGNITION = 1,
  VIDEO_STREAM = 2,
}

struct CameraProcessorConfig {
  1: required list<CameraPipelineType> pipelines_to_run,
  2: optional apriltag.AprilDetectionConfig apriltag_detection_config,
  3: optional image_recognition.ObjectRecognitionConfig object_recognition_config,
  4: optional video_stream.LiveVideo live_video_config,
}