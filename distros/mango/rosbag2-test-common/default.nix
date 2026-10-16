
# Copyright 2026 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

{ lib, buildRosPackage, fetchurl, ament-cmake, ament-cmake-python, ament-cmake-ros-core, ament-lint-auto, ament-lint-common, rclcpp, rclcpp-action, rcpputils, rcutils, test-msgs }:
buildRosPackage {
  pname = "ros-mango-rosbag2-test-common";
  version = "0.35.0-r1";

  src = fetchurl {
    url = "https://github.com/ros2-gbp/rosbag2-release/archive/release/rolling/rosbag2_test_common/0.35.0-1.tar.gz";
    name = "0.35.0-1.tar.gz";
    sha256 = "fe83496e30f3fdaa6c8f4c2108044c5b6a2331554dd32e54c5bc56540927a0fc";
  };

  buildType = "ament_cmake";
  buildInputs = [ ament-cmake ament-cmake-python ament-cmake-ros-core rclcpp rclcpp-action rcpputils rcutils test-msgs ];
  checkInputs = [ ament-lint-auto ament-lint-common ];
  nativeBuildInputs = [ ament-cmake ament-cmake-python ament-cmake-ros-core ];
  rosBuildExportDepends = [ rclcpp rclcpp-action rcpputils rcutils test-msgs ];
  rosExecDepends = [ rclcpp rclcpp-action rcpputils rcutils test-msgs ];

  meta = {
    description = "Commonly used test helper classes and fixtures for rosbag2";
    license = with lib.licenses; [ asl20 ];
  };
}
