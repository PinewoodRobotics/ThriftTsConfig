namespace py config.video_stream

struct LiveVideo {
  1: required bool overlay_tags = false
  2: required string publication_topic = "",
  3: required bool do_compression = true,
  4: required i32 compression_quality = 90,
}
