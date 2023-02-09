const express = require("express");
var yahooFinance = require("yahoo-finance");
const https = require("https");
const PORT = 3000;

const app = express();

// This API is used to build chart for the selected stock
// sending min and max value for chart re rendering min and max value
app.get("/stocks", async (req, res) => {
  const stock = req.query['stock'];
  const data = await yahooFinance.historical({
    symbols: [stock],
    from: req.query['startDate'],
    to: req.query['endDate'],
  });
  let min = 0;
  let max = 0;
  data[stock].forEach((ele) => {
    if (ele.close < min || min == 0) {
      min = ele.close;
    }
    if (ele.close > max) {
      max = ele.close;
    }
  });

  res.json({ status: 200, data: data[stock], minValue: min, maxValue: max });
});

// This API will return the details of the 10 mocked stocks details includes
// stock price, quantity and some other details
app.get("/stockPrice", async (req, res) => {
  const data = await yahooFinance.quote({
    symbols: [
      "AAPL",
      "MSFT",
      "GOOG",
      "GOOGL",
      "AMZN",
      "TSLA",
      "META",
      "NVDA",
      "PEP",
      "COST",
    ],
    modules: ["price"],
  });
  res.json({ status: 200, data: data });
});

// This API will return the top 10 news on stocks 
// This API has an limitation of 100 per day
app.get("/news", async (req, res) => {
  await https.get(
    "https://gnews.io/api/v4/search?q=stocks&apikey=70e7e4ae0a97b5f8c89a89ad42c0a0ad",
    (response) => {
      var body = [];
      response.on("data", (chunk) => {
        body.push(chunk);
      });
      response.on("end", () => {
        try {
          body = JSON.parse(Buffer.concat(body).toString());
        } catch (e) {
          reject(e);
        }
        console.log(body);
        res.json({ status: 200, data: body.articles });
      });
    }
  );
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected at port : ${PORT}`);
});
