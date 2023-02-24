lightGreen='\e[0;32m'
lightRed='\e[0;31m'
lightYellow='\e[0;33m'
NC='\e[0m'
info() {
    echo -e "${lightGreen}[info]:${NC} $1"
}
warn() {
    echo -e "${lightYellow}[warn]:${NC} $1"
}
error() {
    echo -e "${lightRed}[error]:${NC} $1"
    exit 1
}
