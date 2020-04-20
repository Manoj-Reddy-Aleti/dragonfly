#!/bin/bash
set -ue ${DEBUG:+-x}

sed -i "s/JenkinsBuildNo/${BUILD_NUMBER}/1" Dragonfly_pods.yaml