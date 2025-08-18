app:
	tuist version
	tuist install
	tuist cache

	TUIST_DEVELOPMENT_TEAM=$(team) \
	TUIST_APP_VERSION=$(version) \
	TUIST_BUILD_NUMBER=$(shell git rev-list HEAD --count) \
	tuist generate

.PHONY: app
