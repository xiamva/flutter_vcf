import 'package:dio/dio.dart';
import 'package:flutter_vcf/models/pome/response/qc_lab_pome_response.dart';
import 'package:flutter_vcf/models/pome/response/qc_lab_pome_statistics_response.dart';
import 'package:flutter_vcf/models/pome/response/qc_sampling_pome_vehicles_response.dart';
import 'package:flutter_vcf/models/pome/response/submit_qc_sampling_pome_response.dart';
import 'package:flutter_vcf/models/pome/response/unloading_pome_response.dart';
import 'package:flutter_vcf/models/pome/response/unloading_pome_statistics_response.dart';
import 'package:flutter_vcf/models/response/unloading_cpo_response.dart';
import 'package:retrofit/retrofit.dart';
import 'models/unloading_cpo_model.dart';
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
import 'package:flutter_vcf/models/response/submit_unloading_response.dart';





part 'api_service.g.dart';

@RestApi(baseUrl: 'http://172.30.64.197:8000/api/')
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

//CPO ==================== 
  //Sample CPO
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

  //Lab CPO
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

  @GET("/qc/lab/cpo/result/{registrationId}")
    Future<LabDetailResponse> getLabCpoDetail(
      @Header("Authorization") String token,
      @Path("registrationId") String registrationId,
    );

  //Unloading CPO
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

  @POST('unloading/cpo/start')
  Future<SubmitUnloadingResponse> startUnloading(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> payload,
  );

  @POST('unloading/cpo/status')
  Future<SubmitUnloadingResponse> submitUnloadingStatus(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> payload,
  );

  @POST('unloading/cpo/finish')
  Future<SubmitUnloadingResponse> finishUnloading(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> payload,
  );

//POME ====================
  // QC Sampling POME
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

   // QC Lab POME
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

  @GET("/qc/lab/pome/result/{registrationId}")
  Future<LabDetailResponse> getLabPomeDetail(
    @Header("Authorization") String token,
    @Path("registrationId") String registrationId,
  );

  @POST("/qc/lab/pome/submit")
  Future<SubmitLabPomeResponse> submitLabPome(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> payload,
  );

  //Unloading Pome
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

  @POST('unloading/pome/start')
Future<SubmitUnloadingResponse> startUnloadingPome(
  @Header('Authorization') String token,
  @Body() Map<String, dynamic> payload,
);

@POST('unloading/pome/status')
Future<SubmitUnloadingResponse> submitUnloadingPomeStatus(
  @Header('Authorization') String token,
  @Body() Map<String, dynamic> payload,
);

@POST('unloading/pome/finish')
Future<SubmitUnloadingResponse> finishUnloadingPome(
  @Header('Authorization') String token,
  @Body() Map<String, dynamic> payload,
);


}
