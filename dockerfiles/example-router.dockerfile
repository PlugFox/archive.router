FROM plugfox/flutter:beta AS build

# USER root
WORKDIR /home

# Copy app source code and compile it.
COPY --chown=101:101 . .

# Ensure packages are still up-to-date if anything has changed
RUN flutter pub get
RUN flutter pub run build_runner build --delete-conflicting-outputs --release
#RUN flutter pub global run intl_utils:generate
RUN flutter build web --release --no-source-maps \
    --pwa-strategy offline-first \
    --web-renderer canvaskit --dart-define=FLUTTER_WEB_USE_SKIA=true \
    --base-href /router/

FROM nginx:alpine as production

COPY --from=build --chown=101:101 /home/build/web /usr/share/nginx/html

# Add lables
LABEL name="registry.plugfox.dev/example-router" \
      vcs-url="https://github.com/PlugFox/router" \
      github="https://github.com/PlugFox/router" \
      maintainer="Plague Fox <plugfox@gmail.com>" \
      authors="@plugfox" \
      family="plugfox/example"

# Start server.
EXPOSE 80/tcp
