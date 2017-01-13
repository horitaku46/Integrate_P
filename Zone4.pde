

public final class Zone4Const {
  // 描画するテキストの表示Y軸
  static final int TEXT_START_Y_POS = 150;
  // 描画するテキストサイズ
  static final int TEXT_SIZE = 32;
  // テキスト間隔値
  static final int INFO_GAP_TEXT_VALUE = 70;
  // ポイントカラー名の左端X軸
  static final int POINT_COLOR_NAME_LEFT_X = 650;
  // ポイントカウント数の右端X軸
  static final int POINT_COUNT_RIGHT_X = 700;
}


// 獲得色
public enum PointColorType {
  PREV_DETECTED,
  DARK_GREEN,
  GLAY,
  PURPLE,
  THIN_BLUE,
  BLUE;
  
  public int getPointColorArrayNumber() {
    return ordinal() - 1;
  }
}


public class Zone4 extends ZumoInfo {
  
  // ポイントカラーの種類
  private String[] pointColorNameArray = {"深緑色", "灰色", "紫色", "薄い青色", "青色"};
  
  // 獲得したポイントの合計値
  private int darkGreenCount = 0;
  private int grayCount = 0;
  private int purpleCount = 0;
  private int thinBlueCount = 0;
  private int blueCount = 0;
  
  // 前回のポイントカラー値
  private int prevDetectColor = PointColorType.PREV_DETECTED.ordinal();
  
  
  // 画面構成の設定
  @Override
  public void display() {
    // 背景を白色にリセット
    this.resetZoneView();
    
    // 獲得したポイントカラーの回数をインクリメント
    this.pointColorCountor();
    // 取得したポイントカラーの合計値を表示
    this.drawColorPointCount();
  }
  
  
  
  // 獲得したポイントカラーの回数をインクリメント
  private void pointColorCountor() {
    if ( this.prevDetectColor != detectColor_G ) {
      if ( detectColor_G == PointColorType.DARK_GREEN.ordinal() ) {
        this.darkGreenCount++;
        
      } else if ( detectColor_G == PointColorType.GLAY.ordinal() ) {
        this.grayCount++;
        
      } else if ( detectColor_G == PointColorType.PURPLE.ordinal() ) {
        this.purpleCount++;
        
      } else if ( detectColor_G == PointColorType.THIN_BLUE.ordinal() ) {
        this.thinBlueCount++;
        
      } else if ( detectColor_G == PointColorType.BLUE.ordinal() ) {
        this.blueCount++;
      }
    }
    
    // 前回を代入 
    this.prevDetectColor = detectColor_G;
 }
  
  
  
  // 取得したポイントカラーの合計値を表示
  private void drawColorPointCount() {
    // 日本語化
    this.localizationJaText();
    // 文字色を黒
    fill(0);
    // 文字の大きさ
    textSize(Zone4Const.TEXT_SIZE);
    
    for (int index = 0; index < this.pointColorNameArray.length; index++) {
      // 各項目のY軸
      int yPos = Zone4Const.INFO_GAP_TEXT_VALUE * (index + 1) + Zone4Const.TEXT_START_Y_POS;
      
      // ポイントカラー名を右揃え
      textAlign(RIGHT);
      // ポイントカラー名を描画
      text(this.pointColorNameArray[index] + ":", Zone4Const.POINT_COLOR_NAME_LEFT_X, yPos);
      
      // 情報値を左揃え
      textAlign(LEFT);
      // 各項目の設定
      if ( index == PointColorType.DARK_GREEN.getPointColorArrayNumber() ) {
        text(this.darkGreenCount, Zone4Const.POINT_COUNT_RIGHT_X, yPos);
        
      } else if ( index == PointColorType.GLAY.getPointColorArrayNumber() ) {
        text(this.grayCount, Zone4Const.POINT_COUNT_RIGHT_X, yPos);
        
      } else if ( index == PointColorType.PURPLE.getPointColorArrayNumber() ) {
        text(this.purpleCount, Zone4Const.POINT_COUNT_RIGHT_X, yPos);
        
      } else if ( index == PointColorType.THIN_BLUE.getPointColorArrayNumber() ) {
        text(this.thinBlueCount, Zone4Const.POINT_COUNT_RIGHT_X, yPos);
        
      } else if ( index == PointColorType.BLUE.getPointColorArrayNumber() ) {
        text(this.blueCount, Zone4Const.POINT_COUNT_RIGHT_X, yPos);
      }
    }
  }
  
  
}