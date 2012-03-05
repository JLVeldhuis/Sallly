function HeartRate(options) {
    this.context          = options && options.context || false;
    this.frameCount       = 0;
    this.timeline         = new Array(35);
    
    if (this.context) {
        // Timeline..
        this.timeline[0] = 50;
        this.timeline[1] = 50;
        this.timeline[2] = 50;
        this.timeline[3] = 50;
        this.timeline[4] = 50;
        this.timeline[5] = 50;
        this.timeline[6] = 50;
        this.timeline[7] = 50;
        this.timeline[8] = 50;
        this.timeline[9] = 50;
        this.timeline[10] = 45;
        this.timeline[11] = 60;
        this.timeline[12] = 35;
        this.timeline[13] = 100;
        this.timeline[14] = 0;
        this.timeline[15] = 50;
        this.timeline[16] = 50;
        this.timeline[17] = 50;
        this.timeline[18] = 50;
        this.timeline[19] = 50;
        this.timeline[20] = 45;
        this.timeline[21] = 60;
        this.timeline[22] = 35;
        this.timeline[23] = 100;
        this.timeline[24] = 0;
        this.timeline[25] = 50;
        this.timeline[26] = 50;
        this.timeline[27] = 50;
        this.timeline[28] = 50;
        this.timeline[29] = 50;
        this.timeline[30] = 50;
        this.timeline[31] = 50;
        this.timeline[32] = 50;
        this.timeline[33] = 50;
        this.timeline[34] = 50;
        
        // Sprite strip
        this.sprites        = new Image();
        this.sprites.src    = "/assets/images/spritestrip.png";
        this.spriteCount    = 61;
        this.spriteWidth    = 20;
        this.spriteHeight   = 18;
        this.spritesReady   = false;
        
        this.sprites.onload = (function(heartRate) {
                               return function() { heartRate.spritesReady = true; };
                               }(this));
        
        // Graph plot color
        this.plotColor     = "rgba(200, 64, 80, 1)";
    }
}

HeartRate.prototype.calculate = function() {    
    this.frameCount++;
    
    this.drawCount = this.frameCount % 35;
    if (this.drawCount > 34) {
        this.drawCount = 0;
    }
};

// This method calculates FPS and Renders the monitor
HeartRate.prototype.monitor = function() {
    this.calculate();
    
    var ctx = this.context;
    
    if (ctx && this.spritesReady) {
        var plotScale = 4;
        var spriteWidth = this.spriteWidth;
        var spriteHeight = this.spriteHeight;
        
        ctx.save();
        ctx.translate(0, 0);
        
        // Background
        ctx.fillStyle = "rgb(255, 255, 255)";
        ctx.fillRect(0, 0, 435, 250);
        
        ctx.drawImage(this.sprites, (this.frameCount % this.spriteCount) * spriteWidth, 0, spriteWidth, spriteHeight, 9, 6, spriteWidth, spriteHeight);
        
        // Line graph
        ctx.strokeStyle = this.plotColor;
        
        for (var i = 0, len = this.drawCount; i < len; i++) {
            var plot1 = 50 - this.timeline[i] / 100 * 40, 
            plot2 = 50 - this.timeline[i+1] / 100 * 40;
            
            if (!isNaN(plot1)) { 
                ctx.beginPath();
                ctx.moveTo(i * plotScale + 35, plot1);
                ctx.lineTo((i+1) * plotScale + 35, plot2);
                ctx.stroke();
                ctx.closePath();
            }
        }
        ctx.restore();
    }
};