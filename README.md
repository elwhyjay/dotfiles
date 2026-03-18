# Dotfiles
Personal dotfiles for macOS and Linux.

## Setup
```bash
git clone https://github.com/yj/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` handles: symlinks, packages (brew/apt), vim-plug, TPM, NVM, Rust, Nerd Font.

### Manual steps after install
1. Restart terminal (or `exec zsh`)
2. `p10k configure`
3. tmux: `prefix + I` to install plugins
4. nvim: `:PlugInstall` if plugins didn't auto-install

---
## Neovim key mappings

Leader key: `,`

### Leader

| Key | Action |
|-----|--------|
| `,n` | NERDTree toggle |
| `,i` | IndentGuides toggle |
| `,g` | Mundo (undo tree) toggle |
| `,f` | fzf LSP menu |
| `,r` | CellularAutomaton make_it_rain |
| `,D` | Insert date |

### Control

| Key | Action |
|-----|--------|
| `C-s` | Save file (normal/insert/visual) |
| `C-a` | Go to beginning of line |
| `C-e` | Go to end of line |
| `C-space` | coc autocomplete trigger |

### Function keys

| Key | Action |
|-----|--------|
| `F5` | Compile & run C/C++ |
| `F7` | DragSelectMode toggle |
| `F8` | Tagbar toggle |

### Others

| Key | Action |
|-----|--------|
| `;` | `:` (command mode) |
| `K` | Show documentation (hover) |
| `Tab` / `S-Tab` | coc completion (insert) / indent (visual) |
| `Alt-1~9` | Switch tab |
| `Alt-t` | New tab |
| `Alt-h/j/k/l` | Resize pane |
| `Alt--` / `Alt-\` | Horizontal / vertical split |

---
## Modern command

| Legacy | Modern Alternative | Description |
|--------|-------------------|-------------|
| ls | eza, lsd | 색상과 아이콘이 있는 디렉토리 리스팅 (exa는 maintenance 중단, eza가 후속) |
| cat | bat, ccat | 문법 하이라이팅과 line numbering 지원 |
| find | fd | 더 빠르고 사용하기 쉬운 파일 검색 |
| grep | ripgrep (rg) | 매우 빠른 텍스트 검색, .gitignore 자동 반영 |
| top | btop, htop, bottom, gtop, glances | 시각적으로 개선된 시스템 모니터링 |
| curl | httpie, xh, curlie | 더 직관적인 HTTP 클라이언트 |
| diff | delta, difftastic | 문법 하이라이팅과 side-by-side 비교 |
| more/less | bat, moar | 개선된 페이저 (bat은 cat 기능도 포함) |
| ps | procs | 색상과 트리 구조로 프로세스 표시 |
| man | tldr, tealdeer | 간결한 예제 중심 매뉴얼 (tealdeer는 tldr의 Rust 구현) |
| cd | zoxide, autojump | 자주 방문하는 디렉토리로 빠른 이동 (frecency 기반) |
| tree | broot, eza -T | 인터랙티브한 디렉토리 트리 탐색 |
| du | dust, dua, ncdu | 시각적인 디스크 사용량 분석 |
| df | duf | 깔끔한 디스크 공간 표시 |
| ping | gping | 그래프 형태의 ping 결과 |
| history | mcfly, atuin | AI 기반 쉘 히스토리 검색 및 동기화 |
| od | hexyl | 컬러풀한 hex viewer |
| sed | sd | 더 직관적인 문자열 치환 |
| sed/awk | jq, yq | JSON/YAML 데이터 처리 (yq는 YAML용) |
| awk | xsv | CSV 데이터 처리 및 분석 |
| mv/cp/rm | nnn, ranger, lf | 터미널 파일 매니저 |
| dig | dog | 더 읽기 쉬운 DNS 조회 도구 |
| vi/vim | neovim, helix | 현대적인 텍스트 에디터 (LSP, Tree-sitter 지원) |
| ssh | mosh | 불안정한 네트워크에서도 연결 유지 |
| watch | viddy | diff 기능이 있는 명령어 반복 실행 |
| time | hyperfine | 통계 기반 벤치마킹 도구 |
| tail -f | lnav | 로그 파일 뷰어 및 분석 도구 |
| cut | choose | 더 직관적한 필드 선택 도구 |
| traceroute | mtr, trippy | 실시간 네트워크 경로 추적 및 진단 |
| - | bandwhich | 프로세스별 네트워크 대역폭 모니터링 |
| - | tokei | 코드 라인 카운터 (언어별 통계) |
| - | gitui | 터미널 기반 Git 클라이언트 |
| - | zenith | 시스템 모니터 (top 대체) |