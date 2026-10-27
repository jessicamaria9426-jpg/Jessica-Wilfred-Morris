FROM gcc:14 AS build
WORKDIR /app
COPY backend/ backend/
COPY Makefile ./
RUN make CC=gcc

FROM debian:bookworm-slim
WORKDIR /app
COPY --from=build /app/echo_server ./echo_server
COPY static/ ./static/
COPY media/ ./media_seed/
COPY docker-start.sh ./docker-start.sh
RUN chmod +x ./docker-start.sh
ENV PORT=10000
EXPOSE 10000
CMD ["./docker-start.sh"]
