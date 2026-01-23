import 'package:dio/dio.dart';
// import 'package:flutter_vcf/CPO/Unloading%20CPO/input_unloading_cpo.dart';
import 'package:flutter_vcf/models/master/response/master_hole_response.dart';
import 'package:flutter_vcf/models/master/response/master_tank_response.dart';
import 'package:flutter_vcf/models/pk/response/lab_pk_detail_response.dart';
import 'package:flutter_vcf/models/pk/response/qc_lab_pk_statistics_response.dart';
import 'package:flutter_vcf/models/pk/response/qc_lab_pk_vehicles_response.dart';
import 'package:flutter_vcf/models/pk/response/qc_sampling_pk_sample_response.dart';
import 'package:flutter_vcf/models/pk/response/qc_sampling_pk_statistics_response.dart';
import 'package:flutter_vcf/models/pk/response/qc_sampling_pk_vehicles_response.dart';
import 'package:flutter_vcf/models/pk/response/submit_lab_pk_response.dart';
import 'package:flutter_vcf/models/pk/response/submit_qc_sampling_pk_response.dart';
import 'package:flutter_vcf/models/pk/response/unloading_pk_detail_response.dart';
import 'package:flutter_vcf/models/pk/response/unloading_pk_response.dart';
import 'package:flutter_vcf/models/pk/response/unloading_pk_statistics_response.dart';
import 'package:flutter_vcf/models/pome/response/qc_lab_pome_response.dart';
import 'package:flutter_vcf/models/pome/response/qc_lab_pome_statistics_response.dart';
import 'package:flutter_vcf/models/pome/response/qc_sampling_pome_vehicles_response.dart';
import 'package:flutter_vcf/models/pome/response/submit_qc_sampling_pome_response.dart';
import 'package:flutter_vcf/models/pome/response/unloading_pome_detail_response.dart';
import 'package:flutter_vcf/models/pome/response/unloading_pome_response.dart';
import 'package:flutter_vcf/models/pome/response/unloading_pome_statistics_response.dart';
import 'package:flutter_vcf/models/response/unloading_cpo_detail_response.dart';
import 'package:flutter_vcf/models/response/unloading_cpo_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_vcf/models/response/submit_unloading_response.dart';
import 'package:flutter_vcf/models/response/unloading_cpo_statistics_response.dart';
import 'package:flutter_vcf/models/response/qc_sampling_cpo_statistics_response.dart';
import 'package:flutter_vcf/models/response/qc_sampling_cpo_vehicles_response.dart';
import 'package:flutter_vcf/models/response/submit_qc_sampling_response.dart';
import 'package:flutter_vcf/models/response/qc_lab_cpo_statistics_response.dart';
import 'package:flutter_vcf/models/response/qc_lab_cpo_vehicles_response.dart';
import 'package:flutter_vcf/models/response/submit_lab_cpo_response.dart';
import 'package:flutter_vcf/models/response/lab_detail_response.dart';
import 'package:flutter_vcf/models/pome/response/qc_sampling_pome_statistics_response.dart';
import 'package:flutter_vcf/models/pome/response/submit_lab_pome_response.dart';
import 'package:flutter_vcf/models/manager/response/manager_check_tickets_response.dart';
import 'package:flutter_vcf/models/manager/response/manager_check_detail_response.dart';
import 'package:flutter_vcf/models/manager/response/manager_check_submit_response.dart';
import 'package:flutter_vcf/models/manager/response/manager_check_statistics_response.dart';
// import 'package:flutter_vcf/models/response/submit_unloading_response.dart';





part 'api_service.g.dart';  

@RestApi(baseUrl: 'http://172.30.64.121:8000/api/')
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

//CPO ==================== 
  //Sample CPO=============
  @GET("/qc/sampling/cpo/statistics")

  Future<QcSamplingCpoStatisticsResponse> getQcSamplingStats(
    @Header("Authorization") String token, {
    @Query("date_from") String? dateFrom,
    @Query("date_to") String? dateTo, 
  });

  @GET("/qc/sampling/cpo/vehicles")
  Future<QcSamplingCpoVehiclesResponse> getQcSamplingCpoVehicles(
    @Header("Authorization") String token
  );
  
  @POST("/qc/sampling/cpo/create")
  Future<SubmitQcSamplingResponse> submitQcSampling(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> payload
  );

  //Lab CPO =================
  @GET("/qc/lab/cpo/statistics")
  Future<QcLabCpoStatisticsResponse> getQcLabCpoStatistics(
    @Header("Authorization") String token,
    {@Query("date_from") String? dateFrom, @Query("date_to") String? dateTo}
  );

  @GET("/qc/lab/cpo/vehicles")
  Future<QcLabCpoVehiclesResponse> getQcLabCpoVehicles(
    @Header("Authorization") String token
  );

  @POST("/qc/lab/cpo/submit")
  Future<SubmitLabCpoResponse> submitLabCpo(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> payload,
  );

  @GET("/qc/lab/cpo/{registrationId}")
  Future<LabDetailResponse> getLabCpoDetail(
    @Header("Authorization") String token,
    @Path("registrationId") String registrationId,
  );



  //Unloading CPO ====================
  @GET("/unloading/cpo/statistics")
  Future<UnloadingCpoStatisticsResponse> getUnloadingCpoStatistics(
    @Header("Authorization") String token, {
    @Query("date_from") String? dateFrom,
    @Query("date_to") String? dateTo,
  });

  @GET('unloading/cpo/vehicles')
  Future<UnloadingCPOResponse> getPosts(
    @Header('Authorization') String token,
  );

  @GET('unloading/cpo/{identifier}')
  Future<UnloadingCPOResponse> getUnloading(
    @Header('Authorization') String token,
    @Path('identifier') String identifier,
  );

  @POST('unloading/cpo/create')
  Future<SubmitUnloadingResponse> submitUnloadingStatus(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> payload,
  );

  @GET('unloading/cpo/{registrationId}')
  Future<UnloadingCpoDetailResponse> getUnloadingCpoDetail(
    @Header("Authorization") String token,
    @Path("registrationId") String registrationId,
  );




    // Master Data (Tank & Hole)
    @GET("/master/tanks")
    Future<MasterTankResponse> getAllTanks(
      @Header("Authorization") String token,
    );

    @GET("/master/holes")
    Future<MasterHoleResponse> getAllHoles(
      @Header("Authorization") String token,
    );




//POME ====================
  // QC Sampling POME ===================
  @GET("/qc/sampling/pome/statistics")
  Future<QcSamplingPomeStatisticsResponse> getQcSamplingPomeStats(
    @Header("Authorization") String token,
    {@Query("date_from") String? dateFrom, @Query("date_to") String? dateTo}
  );

  @GET("/qc/sampling/pome/vehicles")
  Future<QcSamplingPomeVehiclesResponse> getQcSamplingPomeVehicles(
    @Header("Authorization") String token,
  );
  
  @POST("/qc/sampling/pome/create")
  Future<SubmitQcSamplingPomeResponse> submitQcSamplingPome(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> payload,
  );

   // QC Lab POME ======================
   @GET("/qc/lab/pome/statistics")
  Future<QcLabPomeStatisticsResponse> getQcLabPomeStatistics(
    @Header("Authorization") String token, {
    @Query("date_from") String? dateFrom,
    @Query("date_to") String? dateTo,
  });

  @GET("/qc/lab/pome/vehicles")
  Future<QcLabPomeResponse> getQcLabPomeVehicles(
    @Header("Authorization") String token,
  );

  @GET("/qc/lab/pome/{registrationId}")
  Future<LabDetailResponse> getLabPomeDetail( 
    @Header("Authorization") String token,
    @Path("registrationId") String registrationId,
  );

  @POST("/qc/lab/pome/submit")
  Future<SubmitLabPomeResponse> submitLabPome(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> payload,
  );

  //Unloading Pome ==================
  @GET("/unloading/pome/statistics")
  Future<UnloadingPomeStatisticsResponse> getUnloadingPomeStatistics(
    @Header("Authorization") String token, {
    @Query("date_from") String? dateFrom,
    @Query("date_to") String? dateTo,
  });

  @GET("unloading/pome/vehicles")
  Future<UnloadingPOMEResponse> getUnloadingPomeData(
    @Header("Authorization") String token,
  );

  @GET("unloading/pome/{registrationId}")
  Future<UnloadingPomeDetailResponse> getUnloadingPomeDetail(
    @Header("Authorization") String token,
    @Path("registrationId") String registrationId,
  );
 

  @POST("unloading/pome/create")
  Future<SubmitUnloadingResponse> submitUnloadingPome(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> payload,
  );




//PK ==================== 
// PK sample
@GET("/qc/sampling/pk/statistics")
Future<QcSamplingPkStatisticsResponse> getQcSamplingStatsPK(
  @Header("Authorization") String token, {
  @Query("date_from") String? dateFrom,
  @Query("date_to") String? dateTo,
});

@GET("/qc/sampling/pk/vehicles")
Future<QcSamplingPkVehiclesResponse> getQcSamplingPkVehicles(
  @Header("Authorization") String token,
);
@POST("/qc/sampling/pk/create")
  Future<SubmitQcSamplingPkResponse> submitQcSamplingPK(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> payload,
  );

  @GET("/qc/sampling/pk/{registrationId}")
  Future<QcSamplingPkSampleResponse> getQcSamplingPkSample(
    @Header("Authorization") String token,
    @Path("registrationId") String registrationId,
  );

//Pk Lab
  @GET("/qc/lab/pk/statistics")
  Future<QcLabPkStatisticsResponse> getQcLabPkStatistics(
    @Header("Authorization") String token, {
    @Query("date_from") String? dateFrom,
    @Query("date_to") String? dateTo,
  });

  @GET("/qc/lab/pk/vehicles")
  Future<QcLabPkVehiclesResponse> getQcLabPkVehicles(
    @Header("Authorization") String token,
  );
  
  @POST("/qc/lab/pk/submit")
  Future<SubmitLabPkResponse> submitLabPk(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> payload,
  );

  @GET("/qc/lab/pk/{registrationId}")
  Future<LabPkDetailResponse> getLabPkDetail(
    @Header("Authorization") String token,
    @Path("registrationId") String registrationId,
  );

//PK Unloading
  @GET("/unloading/pk/statistics")
  Future<UnloadingPkStatisticsResponse> getUnloadingPkStatistics(
    @Header("Authorization") String token, {
    @Query("date_from") String? dateFrom,
    @Query("date_to") String? dateTo,
  });

  @GET("/unloading/pk/vehicles")
  Future<UnloadingPkResponse> getUnloadingPk(
    @Header("Authorization") String token,
  );

  @GET("/unloading/pk/{registrationId}")
  Future<UnloadingPkDetailResponse> getUnloadingPkDetail(
    @Header("Authorization") String token,
    @Path("registrationId") String registrationId,
  );

  @POST("/unloading/pk/create")
  Future<SubmitUnloadingResponse> submitUnloadingPk(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> payload,
  );

  // ==================== MANAGER CHECK ====================

  @GET("/manager/check/tickets")
  Future<ManagerCheckTicketsResponse> getManagerCheckTickets(
    @Header("Authorization") String token,
    @Query("commodity") String commodity, {
    @Query("stage") String? stage,
  });

  @GET("/manager/check/tickets/{registrationId}/{stage}")
  Future<ManagerCheckDetailResponse> getManagerCheckTicketDetail(
    @Header("Authorization") String token,
    @Path("registrationId") String registrationId,
    @Path("stage") String stage,
  );

  @POST("/manager/check/sampling")
  Future<ManagerCheckSubmitResponse> submitManagerSamplingCheck(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> payload,
  );

  @POST("/manager/check/lab")
  Future<ManagerCheckSubmitResponse> submitManagerLabCheck(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> payload,
  );

  @POST("/manager/check/unloading")
  Future<ManagerCheckSubmitResponse> submitManagerUnloadingCheck(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> payload,
  );

  @GET("/manager/check/statistics")
  Future<ManagerCheckStatisticsResponse> getManagerCheckStatistics(
    @Header("Authorization") String token,
  );
  
}
