public class SpotifyHandler {

	@AuraEnabled
	public static string playSongById(List<String> deviceIds, String uri){
		String endpoint = '/v1/me/player/play?device_id='+deviceIds[0];
		String method = 'PUT';
		String json = '{'+
						'    "uris": '+JSON.serialize(new List<String>{uri})+','+
						'    "position_ms": 0'+
						'}';

						System.debug(json);
		HttpRequest request = createRequest(endpoint, method, json);
		Http http = new Http();
		HttpResponse response = http.send(request);
		List<String> devIds = new List<String>();
		if(response.getStatusCode() == 204){
			return 'success';
		}else{
			throw new AuraHandledException(response.getBody());
		}
	}

	@AuraEnabled
	public static string playPreviousSong(List<String> deviceIds){
		String endpoint = '/v1/me/player/previous';
		String method = 'POST';		
		String jsonBody = '{"device_id":"'+deviceIds[0]+'"}';
		HttpRequest request = createRequest(endpoint, method, jsonBody);
		Http http = new Http();
		HttpResponse response = http.send(request);
		List<String> devIds = new List<String>();
		if(response.getStatusCode() == 200){
			return 'success';
		}else{
			throw new AuraHandledException(response.getBody());
		}
	}

	@AuraEnabled
	public static string playNextSong(List<String> deviceIds){
		String endpoint = '/v1/me/player/next?device_id='+deviceIds[0];
		String method = 'POST';
		String jsonBody = '{"device_id":"'+deviceIds[0]+'"}';
		HttpRequest request = createRequest(endpoint, method, jsonBody);
		Http http = new Http();
		HttpResponse response = http.send(request);
		List<String> devIds = new List<String>();
		if(response.getStatusCode() == 200){
			return 'success';
		}else{
			throw new AuraHandledException(response.getBody());
		}
	}

	@AuraEnabled(cacheable = true)
	public static List<String> getCurrentDeviceId(){
		String endpoint = '/v1/me/player/devices';
		String method = 'GET';
		HttpRequest request = createRequest(endpoint, method, null);
		Http http = new Http();
		HttpResponse response = http.send(request);
		List<String> devIds = new List<String>();
		if(response.getStatusCode() == 200){
			CurrentDeviceDetail currentDevices = (CurrentDeviceDetail)JSON.deserialize(response.getBody(), CurrentDeviceDetail.class);
			if(currentDevices.devices != null){
				for(Device dev : currentDevices.devices){
					if(!devIds.contains(dev.id)){
						devIds.add(dev.id);
					}
				}
			}
			return devIds;
		}else{
			throw new AuraHandledException(response.getBody());
		}
	}

	@AuraEnabled(cacheable = true)
	public static SpotifyUserInfoWrapper getUserInfo(){
		String endpoint = '/v1/me';
		String method = 'GET';
		HttpRequest request = createRequest(endpoint, method, null);
		Http http = new Http();
		HttpResponse response = http.send(request);
		if(response.getStatusCode() == 200){
			SpotifyUserInfoWrapper usInfo = (SpotifyUserInfoWrapper)JSON.deserialize(response.getBody(), SpotifyUserInfoWrapper.class);
			return usInfo;
		}else{
			throw new AuraHandledException(response.getBody());
		}
	}

	@AuraEnabled
	public static SpotifyTrackWrapper searchTrack(String searchKey, String type){
		String encodedSearchKey = EncodingUtil.urlEncode(searchKey, 'UTF-8');
		String endpoint = '/v1/search?q='+encodedSearchKey+'&type='+type;
		String method = 'GET';
		HttpRequest request = createRequest(endpoint, method, null);
		Http http = new Http();
		HttpResponse response = http.send(request);
		if(response.getStatusCode() == 200){
			switch on type {
				when 'track' {
					SpotifyTrackWrapper stw = (SpotifyTrackWrapper) JSON.deserialize(response.getBody(), SpotifyTrackWrapper.class);
					return stw;
				}
			}
			return null;
		}else{
			throw new AuraHandledException(response.getBody());
		}
	}

	public static HttpRequest createRequest(String endpoint, String method, String body){
		HttpRequest request = new HttpRequest();
		request.setEndpoint('callout:Spotify'+endpoint);
		request.setMethod(method);
		if(body != null){
			request.setBody(body);
		}
		request.setHeader('Accept', 'application/json');
		return request;
	}

	public class SpotifyUserInfoWrapper {
		@AuraEnabled
		public String country;
		@AuraEnabled
		public String display_name;
		@AuraEnabled
		public String email;
		@AuraEnabled
		public ExplicitContent explicit_content;
		@AuraEnabled
		public ExternalUrls external_urls;
		@AuraEnabled
		public Followers followers;
		@AuraEnabled
		public String href;
		@AuraEnabled
		public String id;
		@AuraEnabled
		public List<Image> images;
		@AuraEnabled
		public String product;
		@AuraEnabled
		public String type;
		@AuraEnabled
		public String uri;
	}

	public class ExplicitContent {
		@AuraEnabled
		public Boolean filter_enabled;
		@AuraEnabled
		public Boolean filter_locked;
	}

	public class ExternalUrls {
		@AuraEnabled
		public String spotify;
	}

	public class Followers {
		@AuraEnabled
		public String href;
		@AuraEnabled
		public Integer total;
	}

	public class Image {
		@AuraEnabled
		public String url;
		@AuraEnabled
		public Integer height;
		@AuraEnabled
		public Integer width;
	}

	public class SpotifyTrackWrapper {
		@AuraEnabled
		public TracksWrapper tracks;
	}

	public class TracksWrapper {
		@AuraEnabled
		public String href;
		@AuraEnabled
		public String next;
		@AuraEnabled
		public Integer offset;
		@AuraEnabled
		public String previous;
		@AuraEnabled
		public Integer total;
		@AuraEnabled
		public List<TrackItem> items;
	}

	public class TrackItem {
		@AuraEnabled
		public Album album;
		@AuraEnabled
		public List<Artist> artists;
		@AuraEnabled
		public Integer disc_number;
		@AuraEnabled
		public Integer duration_ms;
		@AuraEnabled
		public Boolean explicit;
		@AuraEnabled
		public ExternalIds external_ids;
		@AuraEnabled
		public ExternalUrls external_urls;
		@AuraEnabled
		public String href;
		@AuraEnabled
		public String id;
		@AuraEnabled
		public Boolean is_playable;
		@AuraEnabled
		public Restrictions restrictions;
		@AuraEnabled
		public String name;
		@AuraEnabled
		public Integer popularity;
		@AuraEnabled
		public String preview_url;
		@AuraEnabled
		public Integer track_number;
		@AuraEnabled
		public String type;
		@AuraEnabled
		public String uri;
		@AuraEnabled
		public Boolean is_local;
	}

	public class Album {
		@AuraEnabled
		public String album_type;
		@AuraEnabled
		public Integer total_tracks;
		@AuraEnabled
		public ExternalUrls external_urls;
		@AuraEnabled
		public String href;
		@AuraEnabled
		public String id;
		@AuraEnabled
		public List<Image> images;
		@AuraEnabled
		public String name;
		@AuraEnabled
		public String release_date;
		@AuraEnabled
		public String release_date_precision;
		@AuraEnabled
		public Restrictions restrictions;
		@AuraEnabled
		public String type;
		@AuraEnabled
		public String uri;
		@AuraEnabled
		public List<Artist> artists;
	}

	public class Artist {
		@AuraEnabled
		public ExternalUrls external_urls;
		@AuraEnabled
		public String href;
		@AuraEnabled
		public String id;
		@AuraEnabled
		public String name;
		@AuraEnabled
		public String type;
		@AuraEnabled
		public String uri;
	}

	public class ExternalIds {
		@AuraEnabled
		public String isrc;
		@AuraEnabled
		public String ean;
		@AuraEnabled
		public String upc;
	}

	public class Restrictions {
		@AuraEnabled
		public String reason;
	}

	public class CurrentDeviceDetail{
		@AuraEnabled
		public List<Device> devices;
	}

	public class Device {
		@AuraEnabled
        public String id;
		@AuraEnabled
        public Boolean is_active;
		@AuraEnabled
        public Boolean is_private_session;
		@AuraEnabled
        public Boolean is_restricted;
		@AuraEnabled
        public String name;
		@AuraEnabled
        public Boolean supports_volume;
		@AuraEnabled
        public String type;
		@AuraEnabled
        public Integer volume_percent;
    }	
}