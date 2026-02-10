include "../common/common.thrift"

namespace py config.image_recognition

struct ObjectConfig {
  1: required string class_name,
  2: required double confidence_threshold,
  3: required double x_size_meters,
  4: required double y_size_meters,
}

struct ObjectRecognitionConfig {
  1: required list<string> cameras_to_use,
  2: required string model_path,
  3: required string output_topic,
  4: required list<ObjectConfig> objects_to_detect,
  5: required string device,
  6: required double iou_threshold,
  7: required double conf_threshold,
}
