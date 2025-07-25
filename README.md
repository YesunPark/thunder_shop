# thunder_shop

`thunder_shop`은 번개개발단 팀이 준비 중인 **PT Pro 앱**의 자체몰 기능을 위한 쇼핑몰 UI/UX 데모 프로젝트입니다.  
Flutter로 개발되었으며, **판매자와 구매자의 관점을 모두 고려한 화면 설계**를 통해 헬스 관련 제품을 효과적으로 거래할 수 있도록 구성되었습니다.

## 📌 프로젝트 개요

- **PT Pro**는 헬스 퍼스널 트레이닝(PT) 수업을 체계적이고 원활하게 운영할 수 있도록 돕는 회원관리 서비스입니다.
- 트레이너에게는 효율적인 수업 및 회원관리 시스템을, 회원에게는 양질의 수업과 헬스케어 정보를 제공합니다.
- 그 중 `thunder_shop`은 PT Pro 앱 안에서 사용할 **식품/운동보조제/운동용품/헬스케어/PT서비스** 등의 판매를 위한 쇼핑 기능을 담당합니다.

---

## 🧩 주요 기능 소개

### 1. 상품 목록 화면

    - 상품 등록 버튼 (좌상단) : 상품 등록 화면으로 이동합니다.
    - 장바구니 이동 버튼 (우상단) : 장바구니 화면으로 바로 이동할 수 있습니다.
    - 카테고리별 필터링 : 상품을 대분류/소분류로 정리하여 사용자가 원하는 제품을 쉽게 찾을 수 있습니다.
    - 좋아요 기능 : 하트를 누르면 썬더 샵의 메인 컬러(파란색)로 채워지며, 상세 화면과 연동됩니다.
    - 빠른 장바구니 담기 : 상세 페이지에 들어가지 않고도 목록에서 바로 1개의 상품을 장바구니에 추가할 수 있습니다.

### 2. 상품 상세 화면

    - 이미지 스와이프 : 복수의 상품 이미지가 있을 경우 좌우 스와이프를 통해 확인할 수 있습니다.
    - 가격 정보 : 원가와 할인가가 구분되어 표시되며, 할인이 있을 경우 할인율도 붉은 글씨로 표시됩니다.
    - 배송 정보 : 배송사 및 배송비 표시. 배송비는 결제 금액에 자동 반영됩니다.
    - 상품 세부정보 : 상세 설명 이미지를 등록한 경우 해당 위치에 표시됩니다.
    - 상품 후기 : 해당 상품에 작성된 후기를 볼 수 있습니다.
    - 상품 문의 : 문의 방법을 안내하는 팝업 제공.
    - 좋아요 / 장바구니 추가 : 목록과 연동된 좋아요 및 장바구니 버튼 제공.
    - 하단 구매 AppBar : 수량 선택 후 장바구니 담기 및 바로 구매 버튼 사용 가능.

### 3. 상품 등록 화면

    - 대표 이미지 (필수) : 목록, 상세, 장바구니에 사용될 메인 이미지
    - 추가 이미지 : 서브 이미지 최대 9장 업로드 가능
    - 상품 설명 이미지 : 상세정보 화면의 상품 세부정보에 표시될 설명 이미지
    - 상품명, 카테고리 (2단계 분류), 판매가, 배송정보/배송비 (모두 필수)**  
    - 할인가 : 입력 시 할인율 표시 및 결제 금액에 자동 반영
    - 미리보기 : 입력한 정보를 기반으로 상품 상세 페이지를 미리 확인 가능 (필수값 입력 시에만 가능)
    - 등록하기 : 상품 등록 완료 후 목록에서 바로 확인 가능

### 4. 장바구니 화면

    - 선택 상품 삭제 : 체크된 항목을 일괄 삭제
    - 개별 상품 삭제 : 각 항목의 엑스 버튼으로 제거
    - 전체 선택 / 해제 : 모든 항목을 선택 또는 해제
    - 구매하기 버튼 : 선택된 상품의 총 수량과 금액 표시, 결제 팝업 표시

## 🛠 기술 스택

| 기술 | 설명 |
|------|------|
| Flutter | UI 프레임워크 (cross-platform 지원) |
| Dart | Flutter 개발 언어 |
| Material Design | 기본 UI 구성 요소 사용 |

---

## 🚀 실행 방법

```bash
# Flutter 패키지 설치
flutter pub get

# 프로젝트 실행 (연결된 디바이스 또는 에뮬레이터 필요)
flutter run