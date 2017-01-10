

// 獲得色
public enum DetectedColorType {
  DARK_GREEN,
  GLAY,
  PURPLE,
  THIN_BLUE,
  BLUE;
  
  public int getNumber() {
    return ordinal(); 
  }
}


public class Zone4 extends ZumoInfo {
  
  
  // 画面構成の設定
  @Override
  public void display() {
    // 前描画をリセット
    this.prevDrawReset();
    
    // 背景を白色にリセット
    this.resetZoneView();
    
    // 獲得した色の情報を描画
    this.drawDetectedColorName();
    // 獲得した色の情報を背景色
    this.drawSetBackgroundColor();
  }
  
  
  
  // 検知した色の情報を描画
  private void drawDetectedColorName() {
    // 日本語化
    this.localizationJaText();
    // 文字色を黒
    fill(0);
    // 文字の大きさ
    textSize(30);
    // 情報名を描画
    text("検知したポイントの色:", 310, 30);
    // 検知した色の名前を描画
    text(this.detectColorName(), 620, 30);
  }
  
  
  
  // 検知した色の名前を返す
  private String detectColorName() {
    
    if ( detectColor_G == DetectedColorType.DARK_GREEN.getNumber() ) {
      return "深緑";
    } else if ( detectColor_G == DetectedColorType.GLAY.getNumber() ) {
      return "灰色";
    } else if ( detectColor_G == DetectedColorType.PURPLE.getNumber() ) {
      return "紫色";
    } else if ( detectColor_G == DetectedColorType.THIN_BLUE.getNumber() ) {
      return "薄い青";
    } else if ( detectColor_G == DetectedColorType.BLUE.getNumber() ) {
      return "青";
    } else {
      return "";
    }
  }
  
  
  
  // 獲得した色の情報を背景色
  private void drawSetBackgroundColor() {
    if ( detectColor_G == DetectedColorType.DARK_GREEN.ordinal() ) {
      this.setBackgroundColor(6, 16, 6);
    } else if ( detectColor_G == DetectedColorType.GLAY.ordinal() ) {
      this.setBackgroundColor(72, 92, 72);
    } else if ( detectColor_G == DetectedColorType.PURPLE.ordinal() ) {
      this.setBackgroundColor(75, 25, 25);
    } else if ( detectColor_G == DetectedColorType.THIN_BLUE.ordinal() ) {
      this.setBackgroundColor(15, 26, 62);
    } else if ( detectColor_G == DetectedColorType.BLUE.ordinal() ) {
      this.setBackgroundColor(3, 7, 28);
    }
  }
  
  
  
  // 指定したRGB値で背景色をセット
  private void setBackgroundColor(int red, int green, int blue) {
    fill(red, green, blue); 
    stroke(red, green, blue);
    // ゾーンの領域
    rect(301, 40, 1000, 700);
  }
  
  
}