/* auto generate by HHB_VERSION 3.2.2 */

#include <csi_nn.h>
#include <shl_utils.h>

void *csinn_(char *params_base) {
  struct csinn_session *sess = csinn_alloc_session();
  sess->base_run_mode = CSINN_RM_CPU_GRAPH;
  sess->base_quant_type = CSINN_QUANT_INT8_ASYM_W_SYM;
  sess->model.save_mode = CSINN_RUN_ONLY;
  sess->base_api = CSINN_C906;
  sess->base_dtype = CSINN_DTYPE_INT8;
  sess->dynamic_shape = CSINN_FALSE;
  csinn_session_init(sess);
  csinn_set_input_number(2, sess);
  csinn_set_output_number(1, sess);

  int32_t *shape_0 = malloc(3 * 4);
  shape_0[0] = -1;
  shape_0[1] = 1024;
  shape_0[2] = 1024;
  struct csinn_tensor *input_1 = csinn_alloc_tensor(sess);
  input_1->name = "input_1@@reshape_/MatMul_2_0";
  input_1->dtype = CSINN_DTYPE_INT8;
  input_1->layout = CSINN_LAYOUT_NCHW;
  input_1->dim[0] = 1;
  input_1->dim[1] = 1;
  input_1->dim[2] = 1024;
  input_1->dim[3] = 1024;
  input_1->dim_count = 4;
  memcpy(input_1->qinfo, params_base + 0, sizeof(struct csinn_quant_info) * 1);
  struct csinn_tensor *output_0 = csinn_alloc_tensor(sess);
  output_0->name = "output_0";
  output_0->dtype = CSINN_DTYPE_INT8;
  output_0->layout = CSINN_LAYOUT_NCW;
  output_0->dim[0] = 1;
  output_0->dim[1] = 1024;
  output_0->dim[2] = 1024;
  output_0->dim_count = 3;
  memcpy(output_0->qinfo, params_base + 40, sizeof(struct csinn_quant_info) * 1);
  struct csinn_reshape_params *params_0 = csinn_alloc_params(sizeof(struct csinn_reshape_params), sess);
  params_0->shape = shape_0;
  params_0->shape_num = 3;
  params_0->base.name = "reshape_/MatMul_2";
  csinn_reshape_init(input_1, output_0, params_0);
  int32_t *shape_2 = malloc(3 * 4);
  shape_2[0] = -1;
  shape_2[1] = 1024;
  shape_2[2] = 1024;
  struct csinn_tensor *input_2 = csinn_alloc_tensor(sess);
  input_2->name = "input_2@@reshape_/MatMul_3_2";
  input_2->dtype = CSINN_DTYPE_INT8;
  input_2->layout = CSINN_LAYOUT_NCHW;
  input_2->dim[0] = 1;
  input_2->dim[1] = 1;
  input_2->dim[2] = 1024;
  input_2->dim[3] = 1024;
  input_2->dim_count = 4;
  memcpy(input_2->qinfo, params_base + 80, sizeof(struct csinn_quant_info) * 1);
  struct csinn_tensor *output_2 = csinn_alloc_tensor(sess);
  output_2->name = "output_2";
  output_2->dtype = CSINN_DTYPE_INT8;
  output_2->layout = CSINN_LAYOUT_NCW;
  output_2->dim[0] = 1;
  output_2->dim[1] = 1024;
  output_2->dim[2] = 1024;
  output_2->dim_count = 3;
  memcpy(output_2->qinfo, params_base + 120, sizeof(struct csinn_quant_info) * 1);
  struct csinn_reshape_params *params_2 = csinn_alloc_params(sizeof(struct csinn_reshape_params), sess);
  params_2->shape = shape_2;
  params_2->shape_num = 3;
  params_2->base.name = "reshape_/MatMul_3";
  csinn_reshape_init(input_2, output_2, params_2);
  struct csinn_tensor *output_3 = csinn_alloc_tensor(sess);
  output_3->name = "output_3";
  output_3->dtype = CSINN_DTYPE_INT8;
  output_3->layout = CSINN_LAYOUT_NCW;
  output_3->dim[0] = 1;
  output_3->dim[1] = 1024;
  output_3->dim[2] = 1024;
  output_3->dim_count = 3;
  memcpy(output_3->qinfo, params_base + 160, sizeof(struct csinn_quant_info) * 1);
  struct csinn_matmul_params *params_3 = csinn_alloc_params(sizeof(struct csinn_matmul_params), sess);
  params_3->trans_a = false;
  params_3->trans_b = false;
  params_3->base.name = "batch_matmul_/MatMul_4";
  csinn_matmul_init(output_0, output_2, output_3, params_3);
  int32_t *shape_4 = malloc(4 * 4);
  shape_4[0] = 1;
  shape_4[1] = 1;
  shape_4[2] = 1024;
  shape_4[3] = 1024;
  struct csinn_tensor *output_4 = csinn_alloc_tensor(sess);
  output_4->name = "reshape_output@@/MatMul_5_4";
  output_4->dtype = CSINN_DTYPE_INT8;
  output_4->layout = CSINN_LAYOUT_NCHW;
  output_4->dim[0] = 1;
  output_4->dim[1] = 1;
  output_4->dim[2] = 1024;
  output_4->dim[3] = 1024;
  output_4->dim_count = 4;
  memcpy(output_4->qinfo, params_base + 200, sizeof(struct csinn_quant_info) * 1);
  struct csinn_reshape_params *params_4 = csinn_alloc_params(sizeof(struct csinn_reshape_params), sess);
  params_4->shape = shape_4;
  params_4->shape_num = 4;
  params_4->base.name = "reshape_output@@/MatMul_5";
  csinn_reshape_init(output_3, output_4, params_4);
  csinn_set_tensor_entry(input_1, sess);
  csinn_set_input(0, input_1, sess);
  csinn_set_tensor_entry(input_2, sess);
  csinn_set_input(1, input_2, sess);

  csinn_reshape(input_1, output_0, params_0);
  csinn_reshape(input_2, output_2, params_2);
  csinn_matmul(output_0, output_2, output_3, params_3);
  csinn_reshape(output_3, output_4, params_4);
  csinn_set_output(0, output_4, sess);

  csinn_session_setup(sess);
  return sess;
}
void csinn_update_input_and_run(struct csinn_tensor **input_tensors , void *sess) {
  csinn_update_input(0, input_tensors[0], sess);
  csinn_update_input(1, input_tensors[1], sess);
  csinn_session_run(sess);
}
