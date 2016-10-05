require 'gs2/core/AbstractClient.rb'

module Gs2 module Auth
  
  # GS2-Auth クライアント
  #
  # @author Game Server Services, Inc.
  class Client < Gs2::Core::AbstractClient
  
    @@ENDPOINT = 'auth'
  
    # コンストラクタ
    # 
    # @param region [String] リージョン名
    # @param gs2_client_id [String] GSIクライアントID
    # @param gs2_client_secret [String] GSIクライアントシークレット
    def initialize(region, gs2_client_id, gs2_client_secret)
      super(region, gs2_client_id, gs2_client_secret)
    end
    
    # デバッグ用。通常利用する必要はありません。
    def self.ENDPOINT(v = nil)
      if v
        @@ENDPOINT = v
      else
        return @@ENDPOINT
      end
    end

    # ログイン。<br>
    # <br>
    # GS2のサービスを利用するにあたってユーザの認証に必要となるアクセストークンを発行します。<br>
    # アクセストークンの発行には以下の情報が必要となります。<br>
    # 
    # * ユーザID
    # * サービスID
    # 
    # ユーザID には ログインするユーザのIDを指定してください。<br>
    # GS2 はアカウント管理機能を持ちませんので、ユーザID は別途アカウント管理システムで発行したIDを指定する必要があります。<br>
    # アカウントIDの文字種などには制限はありません。<br>
    # <br>
    # サービスID には任意の文字列を指定できます。<br>
    # ここで指定したサービスIDにもとづいて、その後アクセストークンで利用できるGSIを制限するのに利用します。<br>
    # <br>
    # サービスの制限は GSI(AWSのIAMのようなもの) のセキュリティポリシーで設定することができます。<br>
    # 例えば、GSIに設定されたセキュリティポリシーが service-0001 によるアクセスを許可する。という設定の場合、<br>
    # service-0002 というサービスIDで発行されたアクセストークンとGSIの組み合わせでリクエストを出してもリジェクトされるようになります。<br>
    # <br>
    # これによって、下記のようなアクセスコントロールを同一アカウント内で実現できます。<br>
    # 
    # * GSI(A) 許可するアクション(GS2Inbox:*) 許可するサービス(service-0001)
    # * GSI(B) 許可するアクション(GS2Stamina:*) 許可するサービス(service-0002)
    # 
    # この場合、service-0001 向けに発行されたアクセストークンと GSI(B) の組み合わせではサービスを利用することはできません。<br>
    # そのため、service-0001 向けのアクセストークンでは GS2-Stamina を利用することはできないことになります。<br>
    #
    # @param request [Array]
    #   * serviceId => サービスID
    #   * userId => ユーザID
    def login(request)
      if not request; raise ArgumentError.new(); end
      body = {};
      if request.has_key?('serviceId'); body['serviceId'] = request['serviceId']; end
      if request.has_key?('userId'); body['userId'] = request['userId']; end
      query = {};
      return post(
        'Gs2Auth',
        'Login',
        @@ENDPOINT,
        '/login',
        body,
        query);
    end
  end
end end