module GoogleHelper

  def google_add(size="728-90")
    gadds=""
    if size=="728-90"
      gadds<< %(
      <script type="text/javascript"><!--
      google_ad_client = "pub-9209840558105246";
      /* 728x90, date de création 06/06/08 */
      google_ad_slot = "5898003850";
      google_ad_width = 728;
      google_ad_height = 90;
      //-->
      </script>
      <script type="text/javascript"
      src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
      </script>
      )
    elsif size=="600-160"
      gadds<< %(
      <script type="text/javascript"><!--
      google_ad_client = "pub-9209840558105246";
      /* 160x600, date de création 06/06/08 */
      google_ad_slot = "3284288514";
      google_ad_width = 160;
      google_ad_height = 600;
      //-->
      </script>
      <script type="text/javascript"
      src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
      </script>

      )
    elsif size=="200-200"
      gadds<< %(
      <script type="text/javascript"><!--
      google_ad_client = "pub-9209840558105246";
      /* 200x200, date de création 06/06/08 */
      google_ad_slot = "6306201390";
      google_ad_width = 200;
      google_ad_height = 200;
      //-->
      </script>
      <script type="text/javascript"
      src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
      </script>
      )
    end
    return gadds
  end


  def google_search_map(searchwhat="",searchwhere="",content_div_id="")  
    retjs=""
     searchwhere_string=searchwhere
     searchwhere_latlng=""

    
    retjs<< %(
    <script language="Javascript" type="text/javascript">
    //<![CDATA[
      google.load("maps", "2",{"language" : "#{session[:locale]}"});
      // google.load("search", "1", {"language" : "#{session[:locale]}"});

      var map = null;
      var geocoder = null;




      function OnLoad() {
        // Create a search control
        //      var searchControl = new google.search.SearchControl();
        //      siteSearch = new GwebSearch();
        //      var options = new GsearcherOptions();
        //      options.setExpandMode(GSearchControl.EXPAND_MODE_OPEN);
        //      searchControl.addSearcher(new GimageSearch(),options);
        //      siteSearch.setUserDefinedLabel("#{searchwhat}");
        //      var localSearch = new google.search.LocalSearch();
        //      localSearch.setCenterPoint("#{searchwhere}");
        //      //searchControl.addSearcher(localSearch);
        //      searchControl.addSearcher(siteSearch);
        //     // Tell the searcher to draw itself and tell it where to attach
        //      searchControl.draw(document.getElementById("gsearch"));
        //     // Execute an inital search
        //      searchControl.execute("#{searchwhat}");


        var map = new google.maps.Map2(document.getElementById("gmap_full"));
        geocoder = new GClientGeocoder();
        var content=$('#{content_div_id}').innerHTML;
        //map.setCenter(gcoder.getLocations('#{searchwhere}'), 13);
        var address="#{searchwhere_string}";
        var latlng="#{searchwhere_latlng}";
        var mapok=true;
        if (geocoder) {
          geocoder.getLatLng(
          address,
          function(point) {

                map.setCenter(point, 16);
                map.enableDoubleClickZoom();
                map.enableScrollWheelZoom();
                var marker = new GMarker(point);
                map.addOverlay(marker);
                marker.openInfoWindowHtml(content);
              
            }
            );
          }
          map.addControl(new GSmallMapControl());
         // map.addControl(new PanoMapTypeControl()); 
      
                
            

         





        }
        google.setOnLoadCallback(OnLoad);

        //]]>
        </script>  
      )
      content_for(:head) {retjs}


      ret=""
      h=Htmlbox.new
      h.all_width("_all")
      h.set_icon_img("google")
      h.set_header("#{"Google map".t}  #{searchwhat}")
      h.set_div_id("search_map_control")
      #   h.set_loader_id("search_map_control_loader")
      #  h.set_wait_loading_message("Loading".t)
      ret<<h.sub_box_title
      ret<<content_tag("div","",:id=>'gmap_full')
      ret<<h.sub_box_end
      return ret

    end

    def google_search_directions(searchwhat="",searchwhere="",content_div_id="")  
        retjs=""
        searchwhere_string=""
        searchwhere_latlng=""
         unless searchwhere.nil?
           searchwhere_string=searchwhere.to_label_no_zip
           unless searchwhere.lat.nil? && searchwhere.lng.nil? 
             searchwhere_latlng="#{searchwhere.lat},#{searchwhere.lng}"
           end
         end
        
        
        retjs<< %(
        <script language="Javascript" type="text/javascript">
        //<![CDATA[
          google.load("maps", "2");
          // google.load("search", "1", {"language" : "#{session[:locale]}"});

          var map;
          var gdir;
          var geocoder = null;
          var addressMarker;
          var locationAddress="#{searchwhere_string}";
          var locationLatLng="#{searchwhere_latlng}";
          var triedLatLng=false;
          
          function initializeDirections() {
            if (GBrowserIsCompatible()) {      
              map = new GMap2(document.getElementById("gmap"));
              gdir = new GDirections(map, document.getElementById("directions"));
             // var first = new GLatLng(61.520076,-149.589844); 
               
              
              GEvent.addListener(gdir, "load", onGDirectionsLoad);
              GEvent.addListener(gdir, "error", handleErrors);
              if (userAddress==""){
                userAddress="#{searchwhere_string}"
              }
      
             // if ($('fromAddress')){
                $('fromAddress').value=userAddress;
              //}
              if ($('toAddress')){
                 $('toAddress').value=locationAddress;
              }
              if (locationAddress!=""){
                setDirections(userAddress, locationAddress , "#{session[:locale]}");
              }
             
            }
          }

          function setDirections(fromAddress, toAddress,locale) {
            gdir.load("from: " + fromAddress + " to: " + toAddress, { "locale": locale });
            triedLatLng=false;
    
            
          }
    
          function handleErrors(){
           if (gdir.getStatus().code == G_GEO_UNKNOWN_ADDRESS){
             //alert("No corresponding geographic location could be found for one of the specified addresses. This may be due to the fact that the address is relatively new, or it may be incorrect. Error code: " + gdir.getStatus().code);
             //alert("triedLatLng="+triedLatLng);
             if (!triedLatLng){
               setDirections(userAddress, locationLatLng , "#{session[:locale]}");
                if ($('toAddress')){
                    $('toAddress').value=locationLatLng;
                 }
               triedLatLng=true;
             }
             //
           }
           else if (gdir.getStatus().code == G_GEO_SERVER_ERROR)
              alert("A geocoding or directions request could not be successfully processed, yet the exact reason for the failure is not known. Error code: " + gdir.getStatus().code);

            else if (gdir.getStatus().code == G_GEO_MISSING_QUERY)
              alert("The HTTP q parameter was either missing or had no value. For geocoder requests, this means that an empty address was specified as input. For directions requests, this means that no query was specified in the input. Error code: " + gdir.getStatus().code);

              //   else if (gdir.getStatus().code == G_UNAVAILABLE_ADDRESS)  <--- Doc bug... this is either not defined, or Doc is wrong
              //     alert("The geocode for the given address or the route for the given directions query cannot be returned due to legal or contractual reasons.  Error code: " + gdir.getStatus().code);

            else if (gdir.getStatus().code == G_GEO_BAD_KEY)
              alert("The given key is either invalid or does not match the domain for which it was given. Error code: " + gdir.getStatus().code);

            else if (gdir.getStatus().code == G_GEO_BAD_REQUEST)
              alert("A directions request could not be successfully parsed. Error code: " + gdir.getStatus().code);

            else alert("An unknown error occurred.");

            }

            function onGDirectionsLoad(){ 
              // Use this function to access information about the latest load()
              // results.

              // e.g.
              // document.getElementById("getStatus").innerHTML = gdir.getStatus().code;
              // and yada yada yada...
            }
            //]]>
            </script>  
            )
            content_for(:head) {retjs}
            content_for(:body_extra){ " onload=\"initializeDirections()\" onunload=\"GUnload()\""}
              #content_for(:body_extra){ " onunload=\"GUnload()\""}
            retform=%(
            <form action="#" onsubmit="setDirections(this.from.value, this.to.value, this.locale.value); return false">

            <table>

            <tr>

            <td>#{"From".t}<br /><input type="text" size="25" id="fromAddress" name="from"
            value="#{searchwhere_string}"/></td>

            <td align="left">#{"To".t}<br /><input type="text" size="25" id="toAddress" name="to"
            value="#{searchwhere_string}" disabled /></td>
            <th>Language:&nbsp;</th>
            <td colspan="3">
            <select id="locale" name="locale">
      )

       LOCALES.each do |key, value| 
        if Locale.language
          if (key==Locale.language.code)
            selected='selected'
          end
        end
        retform<<"<option value=\"#{key}\" #{selected}>#{key}</option>"
      end 
      retform<<%(
      </select>
      <input name="submit" type="submit" value="#{"Get Directions".t}" />
      </td></tr>
      </table>

      )




      ret=""
      h=Htmlbox.new
      h.all_width("_all")
      h.set_icon_img("google")
      h.set_header("#{"How to get to".t}  #{searchwhat}")
      h.set_div_id("search_map_control")
      #   h.set_loader_id("search_map_control_loader")
      #  h.set_wait_loading_message("Loading".t)
      ret<<h.sub_box_title
      ret<<retform
      ret<<content_tag("div","",:id=>'gmap')
      ret<<content_tag("div","",:id=>'directions')
      ret<<h.sub_box_end
      return ret

    end





  def google_search_box(searchwhat="",restriction=true)  
    retjs=""
    retjs<< %(
    <script language="Javascript" type="text/javascript">
    //<![CDATA[
      google.load("search", "1", {"language" : "#{session[:locale]}"});
      function OnLoad() {
        // Create a search control
        var searchControl = new google.search.SearchControl();


        siteSearch = new GwebSearch();
        var options = new GsearcherOptions();
        options.setExpandMode(GSearchControl.EXPAND_MODE_OPEN);
        searchControl.addSearcher(new GimageSearch(),options);
        // siteSearch.setUserDefinedLabel("#{searchwhat}");
        )
        if restriction

          if session[:locale]=="fr"
            retjs<< %(
            siteSearch.setSiteRestriction("011987441359413439661:nundazi0jcs");
            )
          elsif  session[:locale]=="de"
            retjs<< %(
            siteSearch.setSiteRestriction("011987441359413439661:vdajbl6s4w4");
            )
          else 
            retjs<< %(
            siteSearch.setSiteRestriction("011987441359413439661:ppozfxb_yim");
            ) 
          end
        else
          retjs<< %(
          searchControl.addSearcher(new google.search.VideoSearch(),options);
          searchControl.addSearcher(new google.search.BlogSearch());
          var localSearch = new google.search.LocalSearch();
          searchControl.addSearcher(localSearch);
          )


        end
        retjs<< %(

        // to have all opened
        //searchControl.addSearcher(siteSearch,options);
        searchControl.addSearcher(siteSearch);



        //searchControl.addSearcher(new google.search.VideoSearch());
        //searchControl.addSearcher(new google.search.BlogSearch());
        searchControl.addSearcher(new GnewsSearch());

        // Set the Local Search center point
        //localSearch.setCenterPoint("new york, ny");

        // Tell the searcher to draw itself and tell it where to attach
        searchControl.draw(document.getElementById("searchcontrol"));

        // Execute an inital search
        searchControl.execute("#{searchwhat}");
      }
      google.setOnLoadCallback(OnLoad);

      //]]>
      </script>  
      )
      content_for(:head) {retjs}


      ret=""
      h=Htmlbox.new
      h.set_icon_img("google")
      h.set_header("#{"Google search for".t}  #{searchwhat}")
      h.set_div_id("searchcontrol")
      h.set_loader_id("searchcontrol_loader")
      h.set_wait_loading_message("Loading".t)
      ret<<h.sub_box_title
      ret<<h.sub_box_end
      return ret

    end





  def sponsor_box(size="small")
    ret=""
    gadds=""
    if size=="small"
      gadds<< %(
      <script type="text/javascript"><!--
      google_ad_client = "pub-9209840558105246";
      /* 234x60, date de création 29/05/08 */
      google_ad_slot = "3135824283";
      google_ad_width = 234;
      google_ad_height = 60;
      //-->
      </script>
      <script type="text/javascript"
      src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
      </script>
      )
    elsif size=="medium"
      gadds<< %(
      <script type="text/javascript"><!--
      google_ad_client = "pub-9209840558105246";
      /* 336x280, date de création 26/05/08 */
      google_ad_slot = "3190484086";
      google_ad_width = 336;
      google_ad_height = 280;
      //-->
      </script>
      <script type="text/javascript"
      src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
      </script>
      )
    end

    h=Htmlbox.new
    h.set_icon_img("google")
    h.set_header("#{"Sponsors".t} ")
    h.set_div_id("sponsors")
    #  h.set_loader_id("sponsors_loader")
    #  h.set_wait_loading_message("Loading".t)
    ret<<h.sub_box_title
    ret<<gadds
    ret<<h.sub_box_end
    return ret
  end

end