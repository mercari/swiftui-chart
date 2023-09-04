WORKSPACE_PATH := SwiftUIChart.xcworkspace

LIBRARY_SCHEME := "SwiftUI Chart"
EXAMPLE_APP_SCHEME := Example

DESTINATION_TARGET := platform="iOS Simulator,name=iPhone 14 Pro,OS=16.4"


.PHONY: open
open:
	open ${WORKSPACE_PATH}

.PHONY: build-library
build-library:
	@xcodebuild build \
		-workspace ${WORKSPACE_PATH} \
		-scheme ${LIBRARY_SCHEME} \
		-destination ${DESTINATION_TARGET}

.PHONY: test-library
test-library:
	@xcodebuild test \
		-workspace ${WORKSPACE_PATH} \
		-scheme ${LIBRARY_SCHEME} \
		-destination ${DESTINATION_TARGET}

.PHONY: build-example
build-example:
	@xcodebuild build \
		-workspace ${WORKSPACE_PATH} \
		-scheme ${EXAMPLE_APP_SCHEME} \
		-destination ${DESTINATION_TARGET}
