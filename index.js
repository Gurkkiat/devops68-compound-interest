const express = require('express');
const app = express();

app.get('/calculate', (req, res) => {
  const { principal, rate, time, compound } = req.query;
  if (!principal || !rate || !time || !compound) return res.status(400).json({ error: 'Missing parameters' });
  
  const p = parseFloat(principal);
  const r = parseFloat(rate);
  const t = parseFloat(time);
  const n = parseFloat(compound);
  
  if (isNaN(p) || isNaN(r) || isNaN(t) || isNaN(n)) return res.status(400).json({ error: 'All parameters must be numbers' });
  
  const amount = p * Math.pow(1 + (r / 100) / n, n * t);
  const interest = amount - p;
  
  res.json({ principal: p, rate: r, time: t, compound: n, compoundInterest: Math.round(interest * 100) / 100, total: Math.round(amount * 100) / 100 });
});

app.listen(3020, () => console.log('Compound Interest API on port 3020'));
