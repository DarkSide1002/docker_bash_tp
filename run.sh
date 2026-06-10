set -e

mkdir -p data
mkdir -p local_data

case "$1" in
    build_generator)
        echo "Создание образа для контейнера генератора"
        docker build -t start-generator ./generator
        ;;

    run_generator)
        echo "Запуск контейнера генератора"
        if ! docker image inspect start-generator; then
            echo "Образ не найден. Создайте образ с помощью build_generator"
            exit 1
        fi
        docker run --rm -v "$(pwd)/data:/data" start-generator
        ;;

    create_local_data)
        python3 generator/generate.py local_data
        ;;

    build_reporter)
        echo "Создание образа для контейнера репортера"
        docker build -t start-reporter ./reporter
        ;;

    run_reporter)
        echo "Запуск контейнера репортера"
        if ! docker image inspect start-reporter; then
            echo "Образ не найден. Создайте образ с помощью build_reporter"
            exit 1
        fi
        docker run --rm -v "$(pwd)/data:/data" start-reporter
        ;;

    structure)
        echo "Структура проекта:"
        find . -path "./.git" -prune -o -print
        ;;

    clear_data)
        echo "Очистка сгенерированных данных"
        rm -f data/*.csv data/*.html
        ;;

    inside_generator)
        echo "Содержимое /data внутри контейнера генератора"
        if ! docker image inspect start-generator; then
            echo "Образ не найден. Создайте образ с помощью build_generator"
            exit 1
        fi
        docker run --rm -v "$(pwd)/data:/data" start-generator ls -la /data
        ;;

    inside_reporter)
        echo "Содержимое /data внутри контейнера репортера"
        if ! docker image inspect start-reporter; then
            echo "Образ не найден. Создайте образ с помощью build_reporter"
            exit 1
        fi
        docker run --rm -v "$(pwd)/data:/data" start-reporter ls -la /data
        ;;

    report_server)
        if [ ! -f data/report.html ]; then
            echo "Файл data/report.html не найден. Сначала запустите run_generator и run_reporter"
            exit 1
        fi
        docker run --rm -p 8080:80 -v "$(pwd)/data:/usr/share/nginx/html:ro" nginx:alpine
        ;;

    *)
        echo "Неизвестная команда: $1"
        echo "Доступные команды:"
        echo "  build_generator"
        echo "  run_generator"
        echo "  create_local_data"
        echo "  build_reporter"
        echo "  run_reporter"
        echo "  structure"
        echo "  clear_data"
        echo "  inside_generator"
        echo "  inside_reporter"
        echo "  report_server"
        exit 1
        ;;
esac
