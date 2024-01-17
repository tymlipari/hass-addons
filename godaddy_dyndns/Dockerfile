ARG BUILD_FROM
FROM $BUILD_FROM

# Copy our scripts over
WORKDIR /gd_dns
COPY hass_addon.sh /gd_dns
COPY update_godaddy_record.sh /gd_dns
RUN chmod +x /gd_dns/*.sh

CMD [ "/gd_dns/hass_addon.sh" ]