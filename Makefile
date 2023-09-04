WORKSPACE_PATH := SwiftUIChart.xcworkspace

EXAMPLE_APP_SCHEME := Example

DESTINATION_TARGET := platform="iOS Simulator,name=iPhone 14 Pro,OS=16.4"


.PHONY: open
open:
	open ${WORKSPACE_PATH}

.PHONY: build-example
build-example:
	@xcodebuild build \
		-workspace ${WORKSPACE_PATH} \
		-scheme ${EXAMPLE_APP_SCHEME} \
		-destination ${DESTINATION_TARGET}
