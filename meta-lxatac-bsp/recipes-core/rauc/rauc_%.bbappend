FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

do_install:append() {
    install -d ${D}${sysconfdir}/rauc/certificates-available
    install -d ${D}${sysconfdir}/rauc/certificates-enabled

    KEYRING_FILE_NAME=$(basename "${RAUC_KEYRING_FILE}")

    # If RAUC_KEYRING_FILE is not overridden by a customization layer on top
    # of meta-lxatac this will point to devel.cert.pem and the file
    # installed above is overwritten by this mv.
    # If RAUC_KEYRING_FILE is overridden the extra cert will be installed
    # along with the other ones.
    mv ${D}${sysconfdir}/rauc/${KEYRING_FILE_NAME} \
        ${D}${sysconfdir}/rauc/certificates-available/${KEYRING_FILE_NAME}

    # Due to the certificate enable/disable logic in the RAUC hook the
    # following line is only relevant for images _not_ installed via RAUC.
    # Enable the certificate this image was built with.
    ln -s ../certificates-available/${KEYRING_FILE_NAME} \
        ${D}${sysconfdir}/rauc/certificates-enabled/${KEYRING_FILE_NAME}

    openssl rehash ${D}${sysconfdir}/rauc/certificates-enabled
}
