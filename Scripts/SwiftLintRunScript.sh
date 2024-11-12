if test -d "/opt/homebrew/bin/"; then
	PATH="/opt/homebrew/bin/:${PATH}"
fi

export PATH # 환경변수 PATH 사용

# 현재 디렉토리 절대 경로
YML="$(dirname "$0")/.swiftlint.yml"

if which swiftlint > /dev/null; then
	swiftlint --config ${YML}
else
	echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi