document.addEventListener('DOMContentLoaded', () => {
  const qrReader = new Html5Qrcode("qr-reader");

  qrReader.start(
    { facingMode: "environment" },
    { fps: 10 },
    (decodedText) => {
      // Send decoded text to Rails backend
      fetch('/goods/process_qr', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ qr_data: decodedText })
      })
      .then(response => response.json())
      .then(data => {
        if (data.error) {
          alert(data.error);
        } else {
          const { message, options } = data;
          if (options.add_quantity || options.remove_quantity) {
            const action = confirm(`${message}\nDo you want to add quantity? Click "OK" to add, "Cancel" to remove.`);
            const actionType = action ? "add" : "remove";
            const amount = prompt(`Enter amount to ${actionType}:`, "1");

            if (amount && parseInt(amount) > 0) {
              fetch('/goods/update_quantity', {
                method: 'POST',
                headers: {
                  'Content-Type': 'application/json',
                  'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                },
                body: JSON.stringify({
                  name: data.name,
                  action_type: actionType,
                  amount: parseInt(amount)
                })
              })
              .then(res => res.json())
              .then(result => {
                if (result.error) {
                  alert(result.error);
                } else {
                  alert(result.message);
                }
              });
            } else {
              alert("Invalid amount entered.");
            }
          }
        }
      })
      .catch(error => console.error("Error:", error));
    },
    (error) => {
      console.error("QR Code scanning failed:", error);
    }
  );
});
