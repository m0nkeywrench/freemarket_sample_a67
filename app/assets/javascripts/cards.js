$(function() {
  //送信ボタンをクリックでイベントを開始。送信ボタン連打はできないようにする
  $('#token_submit').on('click', function() {
    $('#token_submit').prop('disabled', true);

    var card = {
      number:    $('#card_number').val(),
      cvc:       $('#cvc').val(),
      exp_month: $('#_expiration_date_2i').val(),
      exp_year:  Number($('#_expiration_date_1i').val()) + 2000
    };

    // PayjpのAPIを叩き、レスポンスの結果によって処理を分岐
    Payjp.setPublicKey('pk_test_9ff4e5dcd2f6c31b99b6fa9d');
    Payjp.createToken(card, function(s, response) {
      if (response.error) {
        // エラー時にエラー文言をビューに表示
        $('.card-form__mainForm--error').text("カードの情報が正しくありません。");
        $('.card-form__mainForm--error').css("padding-bottom", "40px")
        $('#token_submit').prop('disabled', false);
      } else {
        // 現状のフォームの情報を全て消した上でトークンだけサーバに飛ばす
        $(".number").removeAttr("name");
        $(".cvc").removeAttr("name");
        $(".month").removeAttr("name");
        $(".year").removeAttr("name");

        var token = response.id;
        $('#charge-form').append($('<input type="hidden" name="payjp-token">').val(token));
        $('#charge-form').get(0).submit();
      }
    });
  });
})