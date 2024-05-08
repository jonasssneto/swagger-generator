JSON_FILES=$(ls json/*.json)
HTML_FILES=""
echo "List of JSON files: $JSON_FILES"

spin() {
    sp="/-\|"
    i=1
    while true
    do
        printf "\b${sp:i++%${#sp}:1}"
        sleep 0.1
    done
}

spin &
SPIN_PID=$!  

for JSON_FILE in $JSON_FILES
do
    echo "Processing file: $JSON_FILE"
    FILE_NAME=$(basename $JSON_FILE .json)
    OUTPUT_FILE="static/$FILE_NAME.html"
    npx redocly build-docs $JSON_FILE -o $OUTPUT_FILE
    echo "Generated file: $OUTPUT_FILE"
    HTML_FILES="$HTML_FILES $OUTPUT_FILE"
done

kill $SPIN_PI
printf "\b "  

HOME_PAGE="index.html"
cat << EOF > $HOME_PAGE
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800&display=swap"
      rel="stylesheet"
    />
    <script src="https://cdn.tailwindcss.com"></script>
    <title>Documentation</title>
  </head>
  <body class="bg-gray-100 text-gray-900">
    <div class="container mx-auto px-6 py-8">
      <div class="flex justify-between items-center pb-6">
        <h1 class="text-2xl font-semibold">List of Documentations</h1>
        <input
          type="text"
          id="search-docs"
          placeholder="Search"
          class="h-9 w-64 rounded-md border border-gray-300 bg-white px-3 text-sm shadow-sm transition focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
        />
      </div>
      <div class="grid md:grid-cols-3 gap-6">
EOF

for HTML_FILE in $HTML_FILES
do
    FILE_NAME=$(basename $HTML_FILE .html)
    cat << EOF >> $HOME_PAGE
        <div class="doc-card p-6 bg-white rounded-lg shadow-md">
          <h2 class="text-lg font-semibold">${FILE_NAME} Documentation</h2>
          <a
            href="${HTML_FILE}"
            class="block mt-4 bg-emerald-600 text-white py-2 px-4 text-center rounded-md hover:bg-emerald-700 transition"
          >
            Open
          </a>
        </div>
EOF
done

cat << EOF >> $HOME_PAGE
      </div>
    </div>
  </body>
</html>

<style>
  * {
    font-family: "Poppins", sans-serif;
    font-weight: 400;
  }
</style>

<script>
  document.getElementById("search-docs").addEventListener("input", function () {
    const searchTerm = this.value.toLowerCase();
    const docCards = document.querySelectorAll(".doc-card");

    docCards.forEach((card) => {
      const cardTitle = card.querySelector("h2").textContent.toLowerCase();

      if (cardTitle.includes(searchTerm)) {
        card.style.display = "block";
      } else {
        card.style.display = "none";
      }
    });
  });
</script>
EOF

echo "Generated home page at $HOME_PAGE"
