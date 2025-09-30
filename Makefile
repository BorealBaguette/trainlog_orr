.PHONY: refresh restart logs stop clean help

# Refresh: Remove GraphHopper data and rebuild containers
refresh:
	@echo "🔄 Refreshing: Removing GraphHopper data and rebuilding..."
	sudo rm -rf osm/filtered_train.osm-gh
	docker compose down
	docker compose up --build -d
	@echo "✅ Refresh complete! Following logs..."
	docker compose logs -f

# Restart: Restart containers without removing GraphHopper data
restart:
	@echo "🔄 Restarting containers (keeping GraphHopper data)..."
	docker compose down
	docker compose up -d
	@echo "✅ Restart complete! Following logs..."
	docker compose logs -f

# Stop containers
stop:
	@echo "⏹️  Stopping containers..."
	docker compose down

# View logs
logs:
	docker compose logs -f

# Clean: Remove containers, volumes, and GraphHopper data
clean:
	@echo "🧹 Cleaning up everything..."
	docker compose down -v
	sudo rm -rf osm/filtered_train.osm-gh
	@echo "✅ Clean complete!"

# Help
help:
	@echo "Available commands:"
	@echo "  make refresh  - Remove GH data, rebuild and restart containers"
	@echo "  make restart  - Restart containers keeping GH data"
	@echo "  make stop     - Stop all containers"
	@echo "  make logs     - Follow container logs"
	@echo "  make clean    - Remove everything (containers, volumes, GH data)"
	@echo "  make help     - Show this help message"