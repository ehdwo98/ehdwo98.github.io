# Personal Homepage (GitHub Pages)

[tommyezreal.github.io](https://tommyezreal.github.io/)와 동일한 [Jon Barron 학술 홈페이지 템플릿](https://github.com/jonbarron/jonbarron.github.io) 기반의 정적 사이트입니다. 빌드 도구 없이 HTML/CSS만으로 구성되어 있어 파일을 수정하고 push하면 바로 반영됩니다.

## 파일 구조

- `index.html` — 페이지 전체 (프로필, Research Interest, Publications, Awards, Experience). 한국어/영어 두 버전이 한 파일에 들어 있습니다. `TODO` 주석이 달린 곳을 본인 정보로 교체하세요.
- `stylesheet.css` — 스타일 (Lato 폰트, 링크 색상 등)
- `images/profile/` — 프로필 사진 (`profile.svg`를 본인 사진 `profile.jpg`로 교체 후 `index.html`의 경로 수정)
- `images/paper/` — 논문 썸네일 이미지 (논문 그림이 없을 때는 `RectifiedEAP.svg`처럼 간단한 SVG 카드를 사용). 페이지 뷰어용 이미지는 `images/paper/<논문>/page-01.jpg` 형식으로 두고 `index.html`의 `.paper-viewer` 블록에서 `data-pages`, `data-src`를 지정
- `papers/` — 사이트에서 열 수 있는 논문 PDF 원본 (`.gitignore`의 `!papers/*.pdf` 예외로 배포됨)
- `publish.sh` — GitHub 리포 생성 + 배포 스크립트

## 로컬 미리보기

```bash
cd ~/djk/ehdwo98.github.io && python3 -m http.server 8000
# 브라우저에서 http://localhost:8000 접속 (VS Code가 포트를 자동 포워딩해줍니다)
```

## 최초 배포

배포 대상: [ehdwo98](https://github.com/ehdwo98) 계정의 `ehdwo98.github.io` 리포 (GitHub Pages 개인 사이트는 리포 이름이 반드시 `<GitHub아이디>.github.io`여야 합니다).

```bash
./publish.sh          # gh 로그인 → 리포 생성 → push까지 자동 처리
```

이후 수정사항 반영은:

```bash
git add -A && git commit -m "Update" && git push
```

push 후 1~2분 뒤 https://ehdwo98.github.io 에서 확인할 수 있습니다.

## 한국어 / English 전환

페이지 우측 상단 버튼으로 언어를 전환합니다. 기본값은 한국어이고, 선택한 언어는 브라우저 `localStorage`에 저장되어 다음 방문에도 유지됩니다.

번역이 필요한 요소는 같은 자리에 `lang="ko"` 블록과 `lang="en"` 블록을 나란히 둡니다. `<html lang>` 값에 따라 `stylesheet.css`가 반대 언어 블록을 숨깁니다. 논문 제목·저자명처럼 양쪽에서 같은 내용은 `lang` 없이 한 번만 씁니다.

```html
<p lang="ko">한국어 문단</p>
<p lang="en">English paragraph</p>
```

## 논문 추가 방법

`index.html`의 Publications 테이블에서 `<tr>` 블록 하나를 복사해 붙여넣고:

1. 썸네일 이미지를 `images/paper/`에 추가하고 `src` 경로 수정
2. 제목(`papertitle` span), 저자, 학회/연도, Paper/Code 링크 수정
3. 한국어 부제(`paper-subtitle`), 학회 표기(`<em lang="ko">` / `<em lang="en">`), 설명(`paper-desc`)을 각 언어로 작성
