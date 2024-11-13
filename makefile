install: # tuist를 이용해서 SPM 설치 
	tuist install

generate: # 프로젝트 만들기
	make install
	TUIST_ENV=DEV TUIST_ROOT_DIR=${PWD} tuist generate

setup: # 기본 셋팅 점검 , 린트 설치 ?  , swiftFormat 설치, tuist 설치 
	sh Scripts/Setup.sh

tp:
	swift Scripts/generatePlugin.swift

module:
	swift Scripts/generateModule.swift

clean:
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

reset:
	tuist clean
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
	
graph: #외부 의존성 그래프에서 제거
	tuist graph -d
