// This is a simple function which forces the heart 
//      to do its double-beat three times.
// I'd recommend using proper looping if you wanted 
//      more. This is just for a demonstration!
function heartbeat(){
  c.animate({
    "0%": {scale: "0.5 0.5"}, 
    "10%": {scale: "0.5 0.5"},
    "15%": {scale: "0.6 0.6"},
    "20%": {scale: "0.5 0.5"},
    "35%": {scale: "0.6 0.6"},
    "40%": {scale: "0.5 0.5"},
    "110%": {scale: "0.5 0.5"},
    "115%": {scale: "0.6 0.6"},
    "120%": {scale: "0.5 0.5"},
    "135%": {scale: "0.6 0.6"},
    "140%": {scale: "0.5 0.5"},
    "210%": {scale: "0.5 0.5"},
    "215%": {scale: "0.6 0.6"},
    "220%": {scale: "0.5 0.5"},
    "235%": {scale: "0.6 0.6"},
    "240%": {scale: "0.5 0.5"},
    "300%": {scale: "0.5 0.5"}
  }, 2500);
}