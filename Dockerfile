FROM eclipse-temurin:17-jdk

# Install dependencies
RUN apt-get update && \
    apt-get install -y maven git nodejs npm && \
    rm -rf /var/lib/apt/lists/*

# Clone and build the OpenRailRouting app
WORKDIR /app
RUN git clone https://github.com/geofabrik/OpenRailRouting.git . && \
    git submodule init && \
    git submodule update && \
    mvn clean package -DskipTests && \
    mkdir -p /app/data /app/graph-cache

# Copy in your custom configuration
COPY config.yml /app/config.yml
COPY custom_models/ /app/custom_models/

EXPOSE 8989

# On startup, always clear the old graph, re-import, then serve
CMD ["sh", "-c", "\
    echo 'Checking for existing graph...' && \
    if [ ! -d \"/app/data/filtered_train.osm-gh\" ]; then \
        echo 'Importing graph from OSM file...'; \
        java -Xmx32g -jar target/railway_routing-*.jar import config.yml; \
    else \
        echo 'Graph already exists, skipping import.'; \
    fi && \
    echo 'Starting server...' && \
    java -Xmx32g -jar target/railway_routing-*.jar serve config.yml \
"]

