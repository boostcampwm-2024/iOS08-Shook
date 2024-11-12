# brew 확인
if test -d "/opt/homebrew/bin/"; then
    PATH="/opt/homebrew/bin/:${PATH}"
fi

if which swiftlint > /dev/null; then
    echo "✅ swiftlint 설치 확인"
else
    echo "❌ swiftlint 설치 필요, swiftlint를 설치합나다."
    brew install swiftlint
fi

if  which swiftformat > /dev/null; then
    echo "✅ swiftformat 설치 확인"
else
    echo "❌ swiftformat 설치 필요, swiftformat을 설치합나다."
    brew install swiftformat
fi

if which tuist > /dev/null; then
    echo "✅ tuist 설치 확인"
else
    echo "❌ tuist 설치 필요 tuist를 설치합나다."

    curl https://mise.run | sh
    echo 'eval "$(~/.local/bin/mise activate --shims zsh)"' >> ~/.zshrc
    source ~/.zshrc

    mise install tuist
    tuist version
fi

echo "✅ 개발 환경 기본 세팅 완료"