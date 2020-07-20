#!/bin/bash

# Grub2 CW

ROOT_UID=0
THEME_DIR="/boot/grub/themes"
THEME_DIR_2="/boot/grub2/themes"
THEME_NAME=cwgrub_v1

# Welcome message
echo -e "\n\t********************************\n\t*      Yükleyici ${THEME_NAME}     *\n\t*          Author:Ns4r         *       \n\t********************************"

# Check command avalibility
function has_command() {
  command -v $1 > /dev/null
}

echo -e "\nRoot Erişimi Kontrol Ediliyor."
if [ "$UID" -eq "$ROOT_UID" ]; then

  echo -e "Sistemdeki tema dizini aranıyor..."
  [[ -d ${THEME_DIR}/${THEME_NAME} ]] && rm -rf ${THEME_DIR}/${THEME_NAME}
  [[ -d ${THEME_DIR_2}/${THEME_NAME} ]] && rm -rf ${THEME_DIR_2}/${THEME_NAME}
  [[ -d /boot/grub ]] && mkdir -p ${THEME_DIR}
  [[ -d /boot/grub2 ]] && mkdir -p ${THEME_DIR_2}

  echo -e "Yüklenecek Tema : ${THEME_NAME} ..."
  [[ -d /boot/grub ]] && cp -a ${THEME_NAME} ${THEME_DIR}
  [[ -d /boot/grub2 ]] && cp -a ${THEME_NAME} ${THEME_DIR_2}

  echo -e "${THEME_NAME} Varsayılan Tema Olarak Ayarlanıyor..."
  grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_THEME=/d' /etc/default/grub
  [[ -d /boot/grub ]] && echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub
  [[ -d /boot/grub2 ]] && echo "GRUB_THEME=\"${THEME_DIR_2}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub
  echo -e "GRUB Yeniden konfigre ediliyor..."
  if has_command update-grub; then
    update-grub
  elif has_command grub-mkconfig; then
    grub-mkconfig -o /boot/grub/grub.cfg
  elif has_command grub2-mkconfig; then
    grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
  fi

  # Success message
  echo -e "\n\t          **************************\n\t          *   Yükleme Tamamlandı.. *\n\t          **************************\n"

else
    # Error message
    echo -e "\n\t   ******************************\n\t   *  HATA! -> /boot/grub/ dizinine erişim yetersiz! Lütfen Yükleyiciyi 'Root' olarak çalıştırın!   *\n\t   ******************************\n"
fi
