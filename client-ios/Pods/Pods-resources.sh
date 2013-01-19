#!/bin/sh

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
      echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "rsync -rp ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -rp "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *)
      echo "cp -R ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
      cp -R "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
      ;;
  esac
}
install_resource 'KSCustomUIPopover/KSCustomPopover/popover-black-bcg-image.png'
install_resource 'KSCustomUIPopover/KSCustomPopover/popover-black-bcg-image@2x.png'
install_resource 'KSCustomUIPopover/KSCustomPopover/popover-black-bottom-arrow-image.png'
install_resource 'KSCustomUIPopover/KSCustomPopover/popover-black-bottom-arrow-image@2x.png'
install_resource 'KSCustomUIPopover/KSCustomPopover/popover-black-left-arrow-image.png'
install_resource 'KSCustomUIPopover/KSCustomPopover/popover-black-left-arrow-image@2x.png'
install_resource 'KSCustomUIPopover/KSCustomPopover/popover-black-right-arrow-image.png'
install_resource 'KSCustomUIPopover/KSCustomPopover/popover-black-right-arrow-image@2x.png'
install_resource 'KSCustomUIPopover/KSCustomPopover/popover-black-top-arrow-image.png'
install_resource 'KSCustomUIPopover/KSCustomPopover/popover-black-top-arrow-image@2x.png'
